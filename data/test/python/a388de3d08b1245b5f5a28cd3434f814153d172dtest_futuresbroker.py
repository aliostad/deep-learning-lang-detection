'''
Created on Apr 23, 2013

@author: rtw
'''
import unittest
from hedgeit.broker.orders import Order
from hedgeit.broker.brokers import BacktestingFuturesBroker
from hedgeit.feeds.multifeed import MultiFeed
from hedgeit.feeds.feed import Feed
from hedgeit.feeds.instrument import Instrument
from hedgeit.feeds.db import InstrumentDb

import os
import datetime

class Test(unittest.TestCase):


    def setUp(self):
        manifest = '%s/data/manifest.csv' % os.path.dirname(__file__)        
        InstrumentDb.Instance().load(manifest)
        

    def tearDown(self):
        pass

    ###########################################################################
    ## Test a basic long market entry order
    
    def on_bars_1(self,bars):
        if not self._placed_markorder:
            o = self._broker.createMarketOrder(Order.Action.BUY, 'AC', 100, False)
            self._broker.placeOrder(o)
            self._placed_markorder = True
        else:
            # we expect by the next Bar that we own the 100 units of AC
            self.assertEqual(self._broker.getPositions()['AC'], 100) 
        #print 'On date %s, cash = %f' % (bars[bars.keys()[0]]['Datetime'], self._broker.getCash())
            
    def on_order_update_1(self, broker, order):
        # 2.215 is open price on day 2 - we expect to execute there
        self.assertEqual(order.getExecutionInfo().getPrice(),2.215)
        
    def testMarketOrder(self):
        self._placed_markorder = False
        mf = MultiFeed()
        mf.register_feed(Feed(InstrumentDb.Instance().get('AC')))
        self._broker = BacktestingFuturesBroker(1000000, mf)
        mf.subscribe(self.on_bars_1)
        self._broker.getOrderUpdatedEvent().subscribe(self.on_order_update_1)
        mf.start()
        self.assertEqual(self._broker.getCash(), 1000015.0)
        self.assertEqual(self._broker.calc_margin(), 160000.0)

    ###########################################################################
    ## Test a basic long market entry order followed by margin call
    
    def on_bars_2(self,bars):
        if not self._placed_markorder:
            o = self._broker.createMarketOrder(Order.Action.BUY, 'CT', 500, False)
            self._broker.placeOrder(o)
            self._placed_markorder = True
        else:
            # we expect by the next Bar that we own the 100 units of AC
            self.assertEqual(self._broker.getPositions()['CT'], 500) 
        #print 'On date %s, cash = %f' % (bars[bars.keys()[0]]['Datetime'], self._broker.getCash())
            
    def on_order_update_2(self, broker, order):
        # 2.215 is open price on day 2 - we expect to execute there
        self.assertEqual(order.getExecutionInfo().getPrice(),92.43)
        
    def testMarketOrderMarginCall(self):
        self._placed_markorder = False
        mf = MultiFeed()
        mf.register_feed(Feed(InstrumentDb.Instance().get('CT')))
        self._broker = BacktestingFuturesBroker(1000000, mf)
        mf.subscribe(self.on_bars_2)
        self._broker.getOrderUpdatedEvent().subscribe(self.on_order_update_2)
        with self.assertRaisesRegexp(Exception, "Margin Call"):
            mf.start()
        self.assertAlmostEqual(self._broker.getCash(), 214000.0, places=2)
        self.assertEqual(self._broker.calc_margin(), 800000.0)

    ###########################################################################
    ## Test a basic short market entry order
    
    def on_bars_3(self,bars):
        if not self._placed_markorder:
            o = self._broker.createMarketOrder(Order.Action.SELL_SHORT, 'CT', 500, False)
            self._broker.placeOrder(o)
            self._placed_markorder = True
        else:
            # we expect by the next Bar that we own the 100 units of AC
            self.assertEqual(self._broker.getPositions()['CT'], -500) 
        #print 'On date %s, cash = %f' % (bars[bars.keys()[0]]['Datetime'], self._broker.getCash())
            
    def on_order_update_3(self, broker, order):
        # 2.215 is open price on day 2 - we expect to execute there
        self.assertEqual(order.getExecutionInfo().getPrice(),92.43)
        
    def testShortEntry(self):
        self._placed_markorder = False
        mf = MultiFeed()
        mf.register_feed(Feed(InstrumentDb.Instance().get('CT')))
        self._broker = BacktestingFuturesBroker(1000000, mf)
        mf.subscribe(self.on_bars_3)
        self._broker.getOrderUpdatedEvent().subscribe(self.on_order_update_3)
        mf.start()
        self.assertAlmostEqual(self._broker.getCash(), 1119750.0, places=2)
        self.assertEqual(self._broker.calc_margin(), 800000.0)

    ###########################################################################
    ## Test a basic short market entry order followed by margin call
    
    def on_bars_4(self,bars):
        if not self._placed_markorder:
            o = self._broker.createMarketOrder(Order.Action.SELL_SHORT, 'C', 300, False)
            self._broker.placeOrder(o)
            self._placed_markorder = True
        else:
            # we expect by the next Bar that we own the 100 units of AC
            self.assertEqual(self._broker.getPositions()['C'], -300) 
        #print 'On date %s, cash = %f' % (bars[bars.keys()[0]]['Datetime'], self._broker.getCash())
            
    def on_order_update_4(self, broker, order):
        # 2.215 is open price on day 2 - we expect to execute there
        self.assertEqual(order.getExecutionInfo().getPrice(),583.25)
        
    def testShortOrderMarginCall(self):
        self._placed_markorder = False
        mf = MultiFeed()
        mf.register_feed(Feed(InstrumentDb.Instance().get('C')))
        self._broker = BacktestingFuturesBroker(1000000, mf)
        mf.subscribe(self.on_bars_4)
        self._broker.getOrderUpdatedEvent().subscribe(self.on_order_update_4)
        with self.assertRaisesRegexp(Exception, "Margin Call"):
            mf.start()
        self.assertAlmostEqual(self._broker.getCash(), -2352500.0, places=2)
        self.assertEqual(self._broker.calc_margin(), 600000.0)

if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()