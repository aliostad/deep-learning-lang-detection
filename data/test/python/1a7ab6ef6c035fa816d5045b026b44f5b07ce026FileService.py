# _*_ coding:utf-8 _*_

from com.common.check.LocalCheck import LocalCheck
from web.broker.BrokerService import BrokerService
from web.dao.BichonDao import BichonDao
from com.check.agent.module.lock import lock
from web.service.TimerTaskService import TimerTaskService

__author__ = 'Administrator'


class FileService(object):
    checkStatue = {}

    def __init__(self):
        pass

    def readFile(self,hostKey,path):
        broker = BrokerService.getBroker(hostKey)
        data=broker.readFile(path)
        return data

    def overwriteFile(self,hostKey,path,data):
        broker = BrokerService.getBroker(hostKey)
        data=broker.overwriteFile(path,data)
        return data

    def downloadFile(self,hostKey,path):
        broker = BrokerService.getBroker(hostKey)
        data=broker.downloadFile(path)
        return data

