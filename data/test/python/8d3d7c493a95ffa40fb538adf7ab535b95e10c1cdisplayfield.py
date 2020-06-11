# -*- coding: utf-8 -*-

from app.repository.displayfield import DisplayFieldRepository

class DisplayFieldFacade:
    def __init__(self):
        self.repository = DisplayFieldRepository()

    def Load(self,id=None,title=None):
        result= self.repository.Load(id=id,title=title)
        return result


    def Search(self,sort='id',desc=False,start=0,count=10):
        result = self.repository.Search(sort=sort,desc=desc,start=start,count=count)
        return result

    def Save(self,data):
        result = self.repository.Save(data)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result


if __name__=='__main__':
    pass