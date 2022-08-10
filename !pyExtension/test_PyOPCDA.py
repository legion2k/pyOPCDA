# -*- coding: utf-8 -*-

from PyOPCDA import *
def Cb(ItemID, value, date, Quality):
    print(f'{ItemID:<3} {value:<20} {Quality:<6} {date} ')

#cl = TClient('Matrikon.OPC.Simulation.1')
#g = cl.subscript(Cb,1000)
#t = g.addTag('Triangle Waves.Real8')
#t = g.addTag('Triangle Waves.Real4')
#t = g.addTag('Triangle Waves.Int1')
#t = g.addTag('Triangle Waves.Int2')
#t = g.addTag('Triangle Waves.Int4')
#t = g.addTag('Triangle Waves.UInt1')
#t = g.addTag('Triangle Waves.UInt2')
#t = g.addTag('Triangle Waves.UInt4')

cl = TClient('ICONICS.SimulatorOPCDA.2')
g = cl.subscript(Cb,1000)
t = g.addTag('LogicalDataItem')
t = g.addTag('NumericDataItem')
t = g.addTag('TextualDataItem')
#t = g.addTag('Triangle Waves.Int2')
#t = g.addTag('Triangle Waves.Int4')
#t = g.addTag('Triangle Waves.UInt1')
#t = g.addTag('Triangle Waves.UInt2')
#t = g.addTag('Triangle Waves.UInt4')

import datetime
t.write2(236, OPC_QUALITY_BAD, datetime.datetime.utcnow())

print(t)
