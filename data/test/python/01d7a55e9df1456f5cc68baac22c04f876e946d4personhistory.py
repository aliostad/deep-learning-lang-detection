# -*- coding: utf-8 -*-

from app.repository.personhistory import PersonHistoryRepository

class PersonHistoryFacade:
    def __init__(self):
        self.repository = PersonHistoryRepository()

    def Search(self,id=None,uid=None,sort='isrtdate',desc=False,start=0,count=10):
        result = self.repository.Search(id=id,uid=uid,sort=sort,desc=desc,start=start,count=count)
        return result

    def Save(self,data):
        result = self.repository.Save(data)
        return result

    def Remove(self,_id):
        result = self.repository.Remove(_id)
        return result



if __name__=='__main__':
    pass