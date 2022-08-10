# -*- coding: utf-8 -*-
from .PyOPCDA3 import COINIT_MULTITHREADED, CoInitializeEx, CoInitializeSecurity, ConnectToOPC, ServerGetStatus, \
     OPC_STATUS_COMM_FAULT, OPC_STATUS_FAILED, OPC_STATUS_NOCONFIG, OPC_STATUS_RUNNING, OPC_STATUS_SUSPENDED,\
     OPC_STATUS_TEST
from .Group import TGroup as grp
from .loger import TLoger as log

class TClient(log):
    #------------------------------------------------------------------------------------------------------
    def __init__(self, Name='', Host='', GUID=''):
        s = Name if GUID=='' else GUID if Host=='' else '{}/{}'.format(Host, GUID)
        super(TClient,self).__init__('Сервер <{}>'.format(s))
        CoInitializeEx(COINIT_MULTITHREADED)
        CoInitializeSecurity()
        self.__srvIf = None;
        self.__groups = {}
        self.__grpCnt = 0
        self.__name = (Host, Name, GUID)
        self.__connected = False
        self.__stop = False;
        self.__connect(True)
        # ------------------------
        def chek():
            from time import sleep
            while not self.__stop:
                self.__connect()
                sleep(1)
        # ------------------------
        from threading import Thread
        Thread(target=chek).start()
    #------------------------------------------------------------------------------------------------------
    def __del__(self):
        del self.__srvIf;
    #------------------------------------------------------------------------------------------------------
    def __connect(self, raize=False):
        #print('-')
        if self.__srvIf is not None:
            #print('--')
            try:
                #print('---')
                StartTime, CurrentTimem, LastUpdateTime, \
                    ServerState, GroupCount, BandWidthm, \
                    MajorVersion, MinorVersion, BuildNumber, \
                    VendorInfo = ServerGetStatus( self.__srvIf )
                #print(ServerState)
                if ServerState != OPC_STATUS_RUNNING:
                    self.__connected = False
            except :
                self.__connected = False
                self.Errlog('Ошибка проверки статуса')
        if not self.__connected:
            try:
                self.tolog('Установка связи')
                self.__srvIf = ConnectToOPC(Host=self.__name[0], ServerName=self.__name[1], ServerCLSID=self.__name[2])
                self.tolog('Cвязь установлена')
                self.__connected = True
                for g in self.__groups:
                    self.__groups[g]._TGroup__reconnect(self.__srvIf )
            except:
                self.Errlog()
                if raize:
                    raise
    #------------------------------------------------------------------------------------------------------
    def subscript( self, UserCallBack, UpdateRateMS: 'DWORD', DeadBand: float=0.0):
        if not self.__connected:
            return None
        g = grp(self.__srvIf,  UpdateRateMS, self.__grpCnt, DeadBand, UserCallBack)
        self.__groups[self.__grpCnt] = g
        self.__grpCnt += 1
        return g
    #------------------------------------------------------------------------------------------------------
