# -*- coding:utf8 -*-#
__author__ = 'honghao'


class Broker:
    def __init__(self, _broker_stat, _broker_name):
        self._broker_stat = _broker_stat
        self._broker_name = _broker_name

    @property
    def broker_stat(self):
        return self._broker_stat

    @broker_stat.setter
    def broker_stat(self, _broker_stat):
        self._broker_stat = _broker_stat

    @property
    def broker_name(self):
        return self._broker_name

    @broker_name.setter
    def broker_name(self, _broker_name):
        self._broker_name = _broker_name

def get_broker_list():
    broker1 = Broker('green', 'broker_master1')
    print broker1.broker_stat
    broker2 = Broker('green', 'broker_master2')
    broker3 = Broker('red', 'broker_master3')
    broker4 = Broker('green', 'broker_slave1')
    broker5 = Broker('green', 'broker_slave2')
    broker6 = Broker('red', 'broker_slave3')
    broker_list = []
    broker_list.append(broker1)
    broker_list.append(broker2)
    broker_list.append(broker3)
    broker_list.append(broker4)
    broker_list.append(broker5)
    broker_list.append(broker6)
    return broker_list