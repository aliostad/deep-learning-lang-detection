from mysqlitefeed_3 import mysqlitefeed
from pyalgotrade import broker
from pyalgotrade.broker.backtesting import TradePercentage 
from orb import ORB
import analyzer

from db import DB_ORIGIN
symbol = 'Y00'
commission_y00 = 0.0001
orr = 15

class subClass(ORB, analyzer.ANALYZER):
    def __init__(self,feed,instrument,broker,openrange,p_a,p_c,isFinancialFuture, debug):
        ORB.__init__(self, fd, instrument, broker, openrange, p_a,p_c, isFinancialFuture, debug)
        analyzer.ANALYZER.__init__(self)

# from TestStrategy import MyStrategy
# b=MyStrategy(a,"Y00")


fd = mysqlitefeed(DB_ORIGIN,60,5*380)
fd.loadBars(symbol, 20150928, 20151009)
commission = TradePercentage(commission_y00) 
brkr = broker.backtesting.Broker(10000000, fd, commission)

a =  subClass(fd, symbol, brkr, orr, 1, 2, False, False)

a.run()
a.myAppend()


# ds=a.fetchdata("Y00",a.getFrequency(),20150901,20150902,None)
# x=ds[100]
# tmp = x[1].strip().split(':')
# idate=x[0]
# tmp4= int(tmp[0])
# tmp5= int(tmp[1])
# idate1=tri_poly(idate)
# tmp0 = formdatetime_60(x[0], int(str(tmp[0])), int(str(tmp[1])))

# tmp = a.fetchdata("Y00",a.getFrequency(),20150925,20150930,None)



