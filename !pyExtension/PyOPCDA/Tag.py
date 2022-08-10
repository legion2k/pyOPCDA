# -*- coding: utf-8 -*-

from .PyOPCDA3 import GroupAddItem, GroupItemRead, GroupItemWrite, GroupItemWrite2
from .loger import TLoger as log

class TTag(log):
    #------------------------------------------------------------------------------------------------------
    def __init__(self, GroupIf, Tag, TagID):
        super(TTag,self).__init__('Тэг <{}>'.format(Tag))
        self.__tag = Tag
        self.__id  = TagID
        self.__reconnect(GroupIf)
    #------------------------------------------------------------------------------------------------------
    def __del__(self):
        del self.__grp
    #------------------------------------------------------------------------------------------------------
    def __reconnect(self, GroupIf):
        self.__grp = GroupIf
        self.__handel, self.__type = GroupAddItem( GroupIf, self.__tag, self.__id)
    #------------------------------------------------------------------------------------------------------
    @property
    def ID(self):
        return self.__id
    #------------------------------------------------------------------------------------------------------
    @property
    def tag(self):
        return self.__tag
    #------------------------------------------------------------------------------------------------------
    def read(self):
        #""" return Value, DateTime, Type, QualityGood """
        #return res[0], res[1], res[2], res[3]==opc.OPC_QUALITY_GOOD
        """ return Value, DateTime, Type, Quality """
        try:
            Value, DateTime, Type, Quality = GroupItemRead(self.__grp, self.__handel)
            return Value, DateTime, Type, Quality==opc.OPC_QUALITY_GOOD
        except:
            self.Errlog('Чтения записи значения')
            return None
    #------------------------------------------------------------------------------------------------------
    def write(self, value):
        try:
            GroupItemWrite(self.__grp, self.__handel, self.__type, value)
        except:
            self.Errlog('Ошибка записи значения')
    #------------------------------------------------------------------------------------------------------
    def write2(self, value, Quality, DateTime):
        try:
            GroupItemWrite2(self.__grp, self.__handel, self.__type, value)
        except:
            self.Errlog('Ошибка записи значения')
            #log.error('Ошибка записи значения')
    #------------------------------------------------------------------------------------------------------