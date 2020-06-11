# -*- coding: utf-8 -*-

from app.repository.education import EducationRepository

class EducationFacade:
    def __init__(self):
        self.repository = EducationRepository()

    def Load(self,id):
        result= self.repository.Load(id=id)
        return result

    def Search(self,id=None,type=None,sort='id',desc=False,start=0,count=10):
        return self.repository.Search(id=id,type=type,sort=sort,desc=desc,start=start,count=count)

    def Update(self,rank):
        result = self.repository.Update(rank)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result