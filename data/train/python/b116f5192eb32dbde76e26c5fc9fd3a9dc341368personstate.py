# -*- coding: utf-8 -*-

from app.repository.personstate import PersonstateRepository

class PersonstateFacade:
    def __init__(self):
        self.repository = PersonstateRepository()

    def Load(self,id):
        result= self.repository.Load(id=id)
        return result

    def Search(self,id=None,sort='id',desc=False,start=0,count=10):
        return self.repository.Search(id=id,sort=sort,desc=desc,start=start,count=count)

    def Update(self,personstate):
        result = self.repository.Update(personstate)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result