#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pandas as pd

from src.model import Model

class MockModel(Model):
    """
    Model class
    """
    def train(self):
        pass

    def trade(self, broker):
        # actualize open trades
        self.trades = broker.get_open_trades()

        for tick in broker.get_tick_data(self.instrument):
            self.buffer.append(tick)

            # create pandas dataframe and resample data to 5s - example :-)
            df = pd.DataFrame(list(self.buffer), columns=['datetime', 'buy', 'sell'])
            df.set_index('datetime', inplace=True)
            resampled = df.resample('5Min', how={'buy':'ohlc', 'sell':'ohlc'})
            print(resampled)

            ## should we cose some trade?
            #for trade in self.trades:
            #   self.close_position(broker, trade)

            ## should we open some new trade?
            # do the magic and return 0/vlume/-volume
            # volume = xxx
            #self.open_position(broker, self.instrument, -1)

            #broker.get_account_information()

            #print(broker)

# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
