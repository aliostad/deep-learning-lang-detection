# -*- coding: utf-8 -*-

from app.repository.dict import DictRepository

class DictFacade:
    def __init__(self):
        self.repository = DictRepository()

    def Load(self,type,id):
        result= self.repository.Load(type=type,id=id)
        return result

    def Search(self,id=None,type=None,parentid=None,sort='id',desc=False,start=0,count=10):
        result = self.repository.Search(id=id,type=type,parentid=parentid,sort=sort,desc=desc,start=start,count=count)
        return result

    def Save(self,dict):
        result = self.repository.Save(dict)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result