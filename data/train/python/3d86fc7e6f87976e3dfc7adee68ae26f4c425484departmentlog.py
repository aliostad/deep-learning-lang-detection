# -*- coding: utf-8 -*-

from app.repository.departmentlog import DepartmentLogRepository
import datetime

class DepartmentLogFacade:
    def __init__(self):
        self.repository = DepartmentLogRepository()

    def Load(self,id):
        result= self.repository.Load(id=id)
        return result

    def Add(self,department,username,content):
        log = {}
        log['department'] = department
        log['username']=username
        log['content'] = content
        log['isrtdate'] = datetime.datetime.now()
        print(log)
        self.Save(log)
        return True

    def Save(self,log):
        result = self.repository.Save(log)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id=id)
        return result

    def Search(self,department,sort='isrtdate',desc=True,start=0,count=10):
        return self.repository.Search(department=department,sort=sort,desc=desc,start=start,count=count)