# -*- coding: utf-8 -*-

from app.repository.dictmeta import DictmetaRepository

class DictmetaFacade:
    def __init__(self):
        self.repository = DictmetaRepository()

    def Load(self,id=None,name=None,parentid=None):
        result= self.repository.Load(id=id,name=name,parentid=parentid)
        if not result:
            result = {}
        return result

    def Search(self,id=None,parentid=None,desc=True,start=0,count=10):
        result = self.repository.Search(id=id,parentid=parentid,desc=desc,start=start,count=count)
        return result

    def Save(self,value):
        result = self.repository.Save(value)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result