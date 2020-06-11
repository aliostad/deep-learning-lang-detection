# encoding=utf-8
from CommonController import CommonController


class CommonContainer(object):
    def __init__(self):
        self.factoryContainer = {}
        self.commonController = CommonController()  # 添加的所有的设备共享同这个控制器，这样就让所有的设备之间通信有了可能

    def buildFactory(self, FactoryName, devID, protocol):
        self.factoryContainer[devID] = FactoryName(devID, protocol)  # 初始化协议工厂并创建工厂对象
        self.factoryContainer[devID].commonController = self.commonController  # 把公共控制器对象添加到工厂对象中
