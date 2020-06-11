# _*_ coding:utf-8 _*_

from web.broker.BrokerService import BrokerService

__author__ = 'Administrator'


class FileSystemService(object):
    def __init__(self):
        pass

    def partitionInfo(self, hostKey):
        broker = BrokerService.getBroker(hostKey)
        return broker.getDiskInfo()

    def ls(self, hostKey, path):
        broker = BrokerService.getBroker(hostKey)
        return broker.getPathDetail(path)

    def rm(self, hostKey, path):
        broker = BrokerService.getBroker(hostKey)
        return broker.rm(path)

    def cp(self, hostKey, path):
        broker = BrokerService.getBroker(hostKey)
        return broker.cp(path)
