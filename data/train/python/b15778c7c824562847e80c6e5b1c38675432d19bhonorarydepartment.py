# -*- coding: utf-8 -*-

from app.repository.honorarydepartment import HonorarydepartmentRepository

class HonorarydepartmentFacade:
    def __init__(self):
        self.repository = HonorarydepartmentRepository()

    def Load(self,id):
        result= self.repository.Load(id=id)
        return result

    def Search(self,id=None,sort='id',desc=False,start=0,count=10):
        return self.repository.Search(id=id,sort=sort,desc=desc,start=start,count=count)

    def Update(self,honorarydepartment):
        result = self.repository.Update(honorarydepartment)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result