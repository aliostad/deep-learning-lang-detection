# -*- coding: utf-8 -*-

from app.repository.customerfield import CustomerFieldRepository


class CustomerFieldFacade:
    def __init__(self,pollId):
        self.repository = CustomerFieldRepository(pollId=pollId)

    def Load(self,id=None,name=None):
        result= self.repository.Load(id=id,name=name)
        return result

    def Search(self,id=None,name=None,sort='isrtdate',desc=True,start=0,count=10):
        result = self.repository.Search(id=id,name=name,sort=sort,desc=desc,start=start,count=count)
        return result

    def Save(self,data):
        result = self.repository.Save(data)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result


if __name__=='__main__':
    pass