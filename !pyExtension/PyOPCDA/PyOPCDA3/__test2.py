import PyOPCDA3
#help(PyOPCDA3)
print('ini 0x{:X}'.format(PyOPCDA3.CoInitializeEx(PyOPCDA3.COINIT_MULTITHREADED)))
#print('ini 0x{:X}'.format(PyOPCDA3.CoInitialize()))
#print('iniS 0x{:X}'.format(PyOPCDA3.CoInitializeSecurity()))
ServerIf = PyOPCDA3.ConnectToOPC(ServerName='Matrikon.OPC.Simulation.1')
#ServerIf = PyOPCDA3.ConnectToOPC('192.168.56.106','{F8582D2E-88FB-11D0-B850-00C0F0104305}')
print('ServerIf =',ServerIf)

print(PyOPCDA3.ServerGetStatus(ServerIf))

GroupIf, GroupHandle = PyOPCDA3.ServerAddGroup(ServerIf,'', True, 1300, 0, 0.0)
print(GroupHandle, GroupIf, sep=' ; ')

#PyOPCDA3.GroupRemove( ServerIf, GroupHandle, 1 )
##print(66666666666666666)
##exit()

ItemHandle0, CanonicalType0 = PyOPCDA3.GroupAddItem(GroupIf, 'Triangle Waves.Real8',0);
print(ItemHandle0, CanonicalType0, sep=' ; ')

print(PyOPCDA3.GroupItemRead(GroupIf, ItemHandle0))

exit()

##ItemHandle1, CanonicalType1 = PyOPCDA3.GroupAddItem(GroupIf, 'Bucket Brigade.ArrayOfReal8',1)
####ItemHandle1, CanonicalType1 = PyOPCDA3.GroupAddItem(GroupIf, 'Bucket Brigade.Real4',1);
##print(ItemHandle1, CanonicalType1, sep=' ; ')

ItemHandle2, CanonicalType2 = PyOPCDA3.GroupAddItem(GroupIf, 'Random.ArrayOfReal8',2);
print(ItemHandle2, CanonicalType2, sep=' ; ')
##
##ItemHandle3, CanonicalType3 = PyOPCDA3.GroupAddItem(GroupIf, 'Random.ArrayOfString',4,);
##print(ItemHandle3, CanonicalType3, sep=' ; ')

AsyncConnection = 0;

##from threading import Thread
##def stop():
##    import time
##    #time.sleep(10)
##    PyOPCDA3.DelCallBack(GroupIf,AsyncConnection)
##    print('---')
##
##def callBack( var, date, dates, ItemID, ValType, Quality, ):
##    print('\t',var, date, dates, ItemID, '${:X}'.format(ValType), '${:X}'.format(Quality))
##    PyOPCDA3.DelCallBack(GroupIf,AsyncConnection)
##OPCCallback, AsyncConnection = PyOPCDA3.SetCallBack(GroupIf, callBack);
##print(AsyncConnection, OPCCallback, sep=' ; ')





##PyOPCDA3.DelCallBack(GroupIf,AsyncConnection)
##PyOPCDA3.DelCallBack(GroupIf,OPCCallback,AsyncConnection)
##del OPCCallback


from queue import Queue
data_queue = Queue()
class cbClass():
    def __init__(self):
        self.q=0
    def doOnDataChange( self, var, date, dates, ItemID, ValType, Quality,d):
        data_queue.put((var, date, dates, ItemID, ValType, Quality))
        print('\t',var, date ,dates ,ItemID, '${:X}'.format(ValType), '${:X}'.format(Quality))
        self.q += 1;
        if True:#self.q==6:
            PyOPCDA3.DelCallBack(GroupIf,AsyncConnection)
            print('------------')
        print(self.q)
#OPCCallback, AsyncConnection = PyOPCDA3.SetCallBack2(GroupIf,cbClass());
#Thread( target=stop ).start()


from datetime import datetime #, PyOPCDA3.VT_R4
PyOPCDA3.GroupItemWrite(GroupIf, ItemHandle1, PyOPCDA3.VT_R4,[1,"2","3","4","5",])
#PyOPCDA3.GroupItemWrite(GroupIf, ItemHandle1, PyOPCDA3.VT_DATE, datetime(2011,12,31,23,59,58))

PyOPCDA3.GroupRemove(ServerIf, GroupHandle, 1)
