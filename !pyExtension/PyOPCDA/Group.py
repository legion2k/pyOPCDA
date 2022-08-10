# -*- coding: utf-8 -*-

from .PyOPCDA3 import ServerAddGroup, SetCallBack2, OPC_QUALITY_GOOD
from .Tag import TTag as tag
from .loger import TLoger as log

class TGroup(log):
    #------------------------------------------------------------------------------------------------------
    def __init__(self, ServerIf, UpdateRate, GroupID, DeadBand, UserCallBack):
        super(TGroup,self).__init__('Группа №{}'.format(GroupID))
        self.__tags = {}
        self.__tagCnt = 0;
        self.__param = (UpdateRate, GroupID, DeadBand, UserCallBack)
        self.__reconnect(ServerIf)
    #------------------------------------------------------------------------------------------------------
    def __del__(self):
        del self.__srvIf
        del self.__grpIf
        del self.__grpHndl
        del self.__cb
        pass
    #------------------------------------------------------------------------------------------------------
    def __reconnect(self, ServerIf):
        self.__srvIf = ServerIf
        try:
            self.__grpIf, self.__grpHndl = ServerAddGroup( ServerIf, '', True, *self.__param[:-1] )
            # ------------------------
            class __TCallBack():
                def __init__(self, UserCB):
                    self.UserCB = UserCB
                def doOnDataChange(self, value, date, localDate, ItemID, ValType, Quality):
                    if self.UserCB is not None:
                        #self.UserCB(value, date, localDate, ItemID, ValType, Quality)
                        self.UserCB(ItemID, value, date, Quality==OPC_QUALITY_GOOD)
            # ------------------------
            if len(self.__tags)>0:
                self.tolog('Переподключение тегов')
                for tID in self.__tags:
                    t = self.__tags[tID]
                    t._TTag__reconnect(self.__grpIf)
                from time import sleep
                sleep(1)# полсле установки тэгов, нужно небольшая пауза
            if self.__param[-1] is not None:
                self.tolog('Установка функция обратного вызова')
                self.__cb, self.__ACon = SetCallBack2(self.__grpIf, __TCallBack(self.__param[-1]))
            # ------------------------
            self.tolog('Граппа создана')
        except:
            self.Errlog('Ошибка создание группы')
    #------------------------------------------------------------------------------------------------------
    def addTag(self, Tag: str):
        t = tag(self.__grpIf, Tag, self.__tagCnt)
        self.__tags[self.__tagCnt] = t
        self.__tagCnt += 1
        return t
    #------------------------------------------------------------------------------------------------------
    def getTag(self, ID):
        return self.__tags.get(ID)
    #------------------------------------------------------------------------------------------------------
