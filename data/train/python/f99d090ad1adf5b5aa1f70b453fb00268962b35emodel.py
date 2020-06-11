#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from abc import ABCMeta, abstractmethod

from src.pricebuffer import PriceBuffer
from src.driver import Driver

class Model(metaclass=ABCMeta):
    def __init__(self, instrument, mode='all', pricebuffer_size=1000, tick_source=None, **params):
        self.buffer = PriceBuffer(size=pricebuffer_size)
        self.instrument = tuple(instrument)
        self.mode = mode
        self.params = params

        self.trades = []
        if tick_source:
            self.tick_source = Driver.init_module_config(tick_source)
        else:
            self.tick_source = None

    @abstractmethod
    def train(self):
        pass

    def open_position(self, broker, instrument, volume, order_type='market', expiry=None, **args):
        trade = broker.open(instrument, volume, order_type, expiry, **args)
        if trade:
            self.trades.append(trade)
        return trade

    def close_position(self, broker, trade):
        ret = broker.close(trade)
        if ret is not None:
            for t in self.trades:
                if t.id == trade.id:
                    self.trades.remove(t)
                break
        else:
            print("not closed!!")
        return ret

    def trade(self, broker):
        # store broker
        self.broker = broker
        
        # actualize open trades
        self.trades = broker.get_open_trades()
        
        # run pre-trade loop method
        self.pre_trade_loop()
        
        # exec trade loop
        for tick in broker.get_tick_data(self.instrument):
            self.buffer.append(tick)
            self.trade_loop(tick)
        
        # run post-trade loop method
        self.post_trade_loop()

    @abstractmethod
    def pre_trade_loop(self):
        pass

    @abstractmethod
    def post_trade_loop(self):
        pass

    @abstractmethod
    def trade_loop(self, tick):
        pass

    def start(self, broker):
        if self.mode == 'trade':
            self.trade(broker)
        elif self.mode == 'train':
            self.train()
        elif self.mode == 'all':
            self.train()
            self.trade(broker)


# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
