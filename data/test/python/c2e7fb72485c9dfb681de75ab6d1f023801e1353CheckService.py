# _*_ coding:utf-8 _*_

from com.common.check.LocalCheck import LocalCheck
from web.broker.BrokerService import BrokerService
from web.dao.BichonDao import BichonDao
from com.check.agent.module.lock import lock
from web.service.TimerTaskService import TimerTaskService

__author__ = 'Administrator'


class CheckService(object):
    checkStatue = {}

    def __init__(self):
        self.dao = BichonDao()

    def processCheck(self, hostKey, processName):
        broker = BrokerService.getBroker(hostKey)
        return broker.processCheck(processName)

    def portCheck(self, hostKey, port):
        broker = BrokerService.getBroker(hostKey)
        return broker.portCheck(port)

    def urlCheck(self, host, port, resource):
        return LocalCheck.httpCheck(host, port, resource=resource)
    @lock
    def check(self, host, name, port):
        '''mysql check'''
        psData = self.processCheck(host.encode("utf-8"), name.encode("utf-8"))
        portData = self.portCheck(host.encode("utf-8"), port.encode("utf-8"))
        if (len(portData) >=1) and (len(psData) >= 4):
            return True
        else:
            return False

    def checkInstalled(self,hostKey,softName):
        broker = BrokerService.getBroker(hostKey)
        data=broker.execCmd("service  "+softName+"  status")
        if "unrecognized" in data[1]:
            d=broker.execCmd("which "+softName)
            if d[0]!=0:
                return False
            else:
                return True
        else:
            return True

    def mysqlCheck(self, host, name="mysql", port="3306"):
        '''mysql check'''
        return self.check(host, name, port)

    def nginxCheck(self, host, port, name="nginx"):
        '''mysql check'''
        return self.check(host, name, port)


    def checkSoftInstallStatus(self,hostKey):
        softs=self.dao.selectAllSoft()[0]
        data=[]
        for s in softs:
            d={}
            statue=self.checkInstalled(hostKey,s["serviceName"])
            d["name"]=s["serviceName"]
            d["statue"]=statue
            data.append(d)
        return data


    def checkServiceRunning(self,hostKey,serviceName):
        broker = BrokerService.getBroker(hostKey)
        data=broker.execCmd("service  "+serviceName+"  status")
        if "unrecognized" in data[1] or "is not running" in data[1]:
            return False
        else:
            return True



    def iptablesList(self,hostKey):
        broker = BrokerService.getBroker(hostKey)
        data=broker.execCmd("iptables -L")
        return data
