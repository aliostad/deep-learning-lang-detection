#! /usr/bin/env python
# --coding:utf-8--
# coding: utf-8
# ━━━━━━神兽出没━━━━━━
#  　　　┏┓　　　┏┓
#  　　┏┛┻━━━┛┻┓
#  　　┃　　　　　　　┃
#  　　┃　　　━　　　┃
#  　　┃　┳┛　┗┳　┃
#  　　┃　　　　　　　┃
#  　　┃　　　┻　　　┃
#  　　┃　　　　　　　┃
#  　　┗━┓　　　┏━┛
#  　　　　┃　　　┃神兽保佑, 永无BUG!
#  　　　　┃　　　┃Code is far away from bug with the animal protecting
#  　　　　┃　　　┗━━━┓
#  　　　　┃　　　　　　　┣┓
#  　　　　┃　　　　　　　┏┛
#  　　　　┗┓┓┏━┳┓┏┛
#  　　　　　┃┫┫　┃┫┫
#  　　　　　┗┻┛　┗┻┛
#  ━━━━━━感觉萌萌哒━━━━━━
#  Module Desc:clover
#  User: z.mm | 2428922347@qq.com
#  Date: 2016/1/19
#  Time: 17:20

from web.broker.BrokerService import BrokerService

__author__ = 'Administrator'


class ProcessService(object):
    def __init__(self):
        pass

    def getPids(self, hostKey):
        broker = BrokerService.getBroker(hostKey)
        return broker.getPids()

    def getProcessInfo(self, hostKey, processId):
        broker = BrokerService.getBroker(hostKey)
        return broker.getProcessInfo(processId)

    def getCusProcessInfo(self, hostKey, attrs=['pid', 'name', 'username', 'memory_info', 'status', 'memory_percent', 'cpu_percent', 'cpu_times']):
        broker = BrokerService.getBroker(hostKey)
        return broker.getCusProcessInfo(attrs)


