# _*_ coding:utf-8 _*_
from web.broker.Brokers import Broker

__author__ = 'Administrator'


class SecurityService(object):
    def __init__(self):
        pass

    '''杀毒'''

    def antivirus(self, hostKey, path):
        broker = Broker.getBroker(hostKey)
        return broker.antivirus(path)

    '''取消ip限制'''

    def ipOpen(self, hostKey, ip):
        broker = Broker.getBroker(hostKey)
        broker.unLimit(ip)

    '''ip限制'''

    def ipClose(self, hostKey, ip):
        broker = Broker.getBroker(hostKey)
        broker.Limit(ip)

    '''开放端口'''

    def portOpen(self, hostKey, port):
        broker = Broker.getBroker(hostKey)
        broker.openPort(port)

    '''关闭端口'''

    def portClose(self, hostKey, port):
        broker = Broker.getBroker(hostKey)
        broker.closePort(port)

    '''获取iptable列表'''

    def iptables(self, hostKey, port):
        broker = Broker.getBroker(hostKey)
        broker.closePort(port)
