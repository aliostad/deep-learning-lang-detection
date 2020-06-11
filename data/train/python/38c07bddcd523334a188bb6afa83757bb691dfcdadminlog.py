# -*- coding: utf-8 -*-

from app.repository.adminlog import AdminLogRepository
import datetime

class AdminLogFacade:
    def __init__(self):
        self.repository = AdminLogRepository()

    def Load(self,id):
        result= self.repository.Load(id=id)
        return result

    def Add(self,username,content):
        log = {}
        log['username']=username
        log['content'] = content
        log['isrtdate'] = datetime.datetime.now()
        self.Save(log)
        return True

    def Save(self,log):
        result = self.repository.Save(log)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id=id)
        return result

    def Search(self,username=None,sort='isrtdate',desc=True,start=0,count=10):
        return self.repository.Search(username=username,sort=sort,desc=desc,start=start,count=count)