# -*- coding: utf-8 -*-

from app.repository.admin import AdminRepository

class AdminFacade:
    def __init__(self):
        self.repository = AdminRepository()

    def Load(self,id=None,username=None):
        result= self.repository.Load(id=id,username=username)
        return result

    def Save(self,admin):
        result = self.repository.Save(admin)
        return result

    def Remove(self,id=None,username=None):
        result = self.repository.Remove(id=id,username=username)
        return result

    def Search(self,id=None,sort='isrtdate',desc=True,start=0,count=10):
        result = self.repository.Search(id=id,sort=sort,desc=desc,start=start,count=count)
        return result