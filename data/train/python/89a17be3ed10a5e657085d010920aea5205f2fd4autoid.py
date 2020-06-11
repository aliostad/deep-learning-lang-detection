# -*- coding: utf-8 -*-

from app.repository.autoid import AutoIdRepository

class AutoIdFacade:
    '''自动编号类'''
    def __init__(self):
        self.repository = AutoIdRepository()

    def Init(self,name):
        return self.repository.Init(name)

    def Update(self,name,id):
        return self.repository.Update(name=name,id=id)

    def GetCurrentId(self,name):
        return self.repository.GetCurrentId(name=name)

    def GetNewId(self,name):
        return self.repository.GetNewID(name=name)

    def GetAutoIdByName(self,name):
        '''得到当前自动编号，下一个编号将从此号码的下一个号码开始'''
        data = self.repository.Load(name=name)
        return data.get('id',0)

    def GetAll(self):
        return self.repository.GetAll()


if __name__=='__main__':
    pass