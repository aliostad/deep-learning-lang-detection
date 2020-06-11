# coding=utf-8

class Message(object):
    ACCOUNT = ""
    CODE = ""
    DISPATCH = ""
    CALLBACK_INACTIVE = 2
    CALLBACK_FINAL_STATUS = 1
    CALLBACK_FINAL_STATUS_INTEMED = 2
    CALLBACK = 0


    def __init__(self):
        self.CALLBACK = self.CALLBACK_INACTIVE
        
    def setAccount(self, account):
        self.ACCOUNT = account
    
    def getAccount(self):
        return self.ACCOUNT
    
    def setCode(self, code):
        self.CODE = code
    
    def getCode(self):
        return self.CODE    
        
    def setCallBack(self, callback):
        self.CALLBACK = callback
    
    def getCallBack(self):
        return self.CALLBACK
    
    def setDispatch(self, dispach):
        self.DISPATCH = dispach
    
    def getDispatch(self):
        return self.DISPATCH
    
    def getAsArray(self):
        param = {}
        param["account"] = self.getAccount()
        param["code"] = self.getCode()
        param["dispatch"] = self.getDispatch()
        return param