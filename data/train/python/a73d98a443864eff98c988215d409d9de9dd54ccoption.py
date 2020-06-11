# -*- coding: utf-8 -*-

from app.repository.option import OptionRepository

class OptionFacade:
    def __init__(self):
        self.repository = OptionRepository()

    def Load(self):
        result= self.repository.Load()
        return result

    def GetValue(self,key,defaultValue=None):
        option = self.Load()
        if option:
            return option.get(key,defaultValue)
        else:
            return defaultValue


    def Update(self,option):
        result = self.repository.Update(option)
        return result



if __name__=='__main__':
    pass