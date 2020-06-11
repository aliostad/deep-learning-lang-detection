# encoding: utf-8
'''
Created on 2013-11-26

@author: cnzhao
'''
from core.typeDefine import *
from broker.loginBroker import LoginBroker

def DispathCommReq(commMsg):
    broker = None
    if commMsg.msgType == MsgTypeEnumLogin:
        
#         m = __import__('broker.loginBroker', globals(), locals(), ['LoginBroker']) 
#         c= getattr(m, 'LoginBroker') 
#         broker = c(commMsg)
        broker = LoginBroker(commMsg)
        
    elif commMsg.msgType == MsgTypeEnumRegister:
        pass
    broker.startProc()