'''
Created on 10/06/2013

@author: Pablo
'''
from State import *
from DeviceManager import *

class HandlerIO:
    def __init__(self, aManageIRQ):
        self.deviceManage = DeviceManager(aManageIRQ)
            
    def handleIO(self, aPCB , nextInstruccion):
        aPCB.changeStatus(State.WAITING)
        device = nextInstruccion.getDeviceName()
        self.deviceManage.handle(device, aPCB, nextInstruccion)
        
    def initializeThread(self):
        self.deviceManage.initializeThread()
    
    def addDevice(self, aDevice):
        self.deviceManage.addDevice(aDevice)
    
