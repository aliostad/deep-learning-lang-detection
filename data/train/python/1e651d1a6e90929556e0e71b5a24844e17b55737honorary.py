# -*- coding: utf-8 -*-

from app.repository.honorary import HonoraryRepository

class HonoraryFacade:
    def __init__(self):
        self.repository = HonoraryRepository()

    def Load(self,id):
        result= self.repository.Load(id=id)
        return result

    def Search(self,id=None,sort='id',desc=False,start=0,count=10):
        return self.repository.Search(id=id,sort=sort,desc=desc,start=start,count=count)

    def Update(self,honorary):
        result = self.repository.Update(honorary)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result