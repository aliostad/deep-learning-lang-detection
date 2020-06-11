# -*- coding: utf-8 -*-

from app.repository.articlefield import ArticleFieldRepository


class ArticleFieldFacade:
    def __init__(self,pollId):
        self.repository = ArticleFieldRepository(pollId=pollId)

    def Load(self,id=None,name=None,pid=None):
        result= self.repository.Load(id=id,name=name,pid=pid)
        return result

    def Search(self,id=None,name=None,pid=0,sort='order',desc=False,start=0,count=10):
        result = self.repository.Search(id=id,name=name,pid=pid,sort=sort,desc=desc,start=start,count=count)
        return result

    def Save(self,data):
        result = self.repository.Save(data)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result


if __name__=='__main__':
    pass