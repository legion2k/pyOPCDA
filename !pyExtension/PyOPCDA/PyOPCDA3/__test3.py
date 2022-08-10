import PyOPCDA3
from time import sleep
from datetime import datetime, timezone

print('ini 0x{:X}'.format(PyOPCDA3.CoInitializeEx(PyOPCDA3.COINIT_MULTITHREADED)))
ServerIf = PyOPCDA3.ConnectToOPC(ServerName='ICONICS.SimulatorOPCDA.2')
print('ServerIf =',ServerIf)

print(PyOPCDA3.ServerGetStatus(ServerIf))

GroupIf, GroupHandle = PyOPCDA3.ServerAddGroup(ServerIf,'', True, 1300, 0, 0.0)
print(GroupHandle, GroupIf, sep='; ')

#PyOPCDA3.GroupRemove( ServerIf, GroupHandle, 1 )
##print(66666666666666666)
##exit()

ItemHandle0, CanonicalType0 = PyOPCDA3.GroupAddItem(GroupIf, 'LogicalDataItem', 0);
print(ItemHandle0, CanonicalType0, sep='; ')

ItemHandle1, CanonicalType1 = PyOPCDA3.GroupAddItem(GroupIf, 'NumericDataItem', 1);
print(ItemHandle1, CanonicalType1, sep='; ')

PyOPCDA3.GroupItemWrite(GroupIf, ItemHandle1, CanonicalType1, 0)

sleep(2) # in opc: value update rate 500ms
print(PyOPCDA3.GroupItemRead(GroupIf, ItemHandle1))

PyOPCDA3.GroupItemWrite(GroupIf, ItemHandle1, CanonicalType1, 21)

sleep(2) # in opc: value update rate 500ms
print(PyOPCDA3.GroupItemRead(GroupIf, ItemHandle1))

PyOPCDA3.GroupItemWrite2(GroupIf, ItemHandle1, CanonicalType1, 225010, PyOPCDA3.OPC_QUALITY_GOOD)

sleep(2) # in opc: value update rate 500ms
print(PyOPCDA3.GroupItemRead(GroupIf, ItemHandle1))

PyOPCDA3.GroupItemWrite2(GroupIf, ItemHandle1, CanonicalType1, 225010, PyOPCDA3.OPC_QUALITY_GOOD)

sleep(1) # in opc: value update rate 500ms
print(PyOPCDA3.GroupItemRead(GroupIf, ItemHandle1))

PyOPCDA3.GroupItemWrite2(GroupIf, ItemHandle1, CanonicalType1, 225010, PyOPCDA3.OPC_QUALITY_GOOD)

sleep(1) # in opc: value update rate 500ms
print(PyOPCDA3.GroupItemRead(GroupIf, ItemHandle1))

PyOPCDA3.GroupItemWrite2(GroupIf, ItemHandle1, CanonicalType1, 225010, PyOPCDA3.OPC_QUALITY_GOOD)

sleep(1) # in opc: value update rate 500ms
print(PyOPCDA3.GroupItemRead(GroupIf, ItemHandle1))

PyOPCDA3.GroupItemWrite2(GroupIf, ItemHandle1, CanonicalType1, PyOPCDA3.OPC_QUALITY_BAD, TimeStamp=datetime(2000,11,30,10,58,59,tzinfo=timezone.utc ))

PyOPCDA3.GroupItemWrite2(GroupIf, ItemHandle1, CanonicalType1, 222, None)

sleep(1) # in opc: value update rate 500ms
print(PyOPCDA3.GroupItemRead(GroupIf, ItemHandle1,  ))


