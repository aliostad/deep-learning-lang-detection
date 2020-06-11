# -*- coding: utf-8 -*-

from app.repository.data import DataRepository


class DataFacade:
    def __init__(self,pollId):
        self.repository = DataRepository(pollId)

    def CreateIndex(self):
        self.repository.CreateIndex()

    def Load(self,id):
        result= self.repository.Load(id=id)
        return result

    def Search(self,id=None,sort='isrtdate',desc=True,start=0,count=10,dictArg=None):
        result = self.repository.Search(id=id,sort=sort,desc=desc,start=start,count=count,dictArg=dictArg)
        return result

    def Save(self,data):
        result = self.repository.Save(data)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result


if __name__=='__main__':
    pass