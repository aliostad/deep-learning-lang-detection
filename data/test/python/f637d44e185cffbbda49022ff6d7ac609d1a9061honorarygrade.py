# -*- coding: utf-8 -*-

from app.repository.honorarygrade import HonorarygradeRepository

class HonorarygradeFacade:
    def __init__(self):
        self.repository = HonorarygradeRepository()

    def Load(self,id):
        result= self.repository.Load(id=id)
        return result

    def Search(self,id=None,sort='id',desc=False,start=0,count=10):
        return self.repository.Search(id=id,sort=sort,desc=desc,start=start,count=count)

    def Update(self,honorarygrade):
        result = self.repository.Update(honorarygrade)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result