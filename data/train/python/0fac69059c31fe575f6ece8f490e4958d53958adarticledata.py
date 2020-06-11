# -*- coding: utf-8 -*-

from app.repository.articledata import ArticleDataRepository


class ArticleDataFacade:
    def __init__(self,pollId):
        self.repository = ArticleDataRepository(pollId)

    def Load(self,id):
        result= self.repository.Load(id=id)
        return result

    def Search(self,sort='isrtdate',desc=True,start=0,count=10,dictArg=None):
        result = self.repository.Search(sort=sort,desc=desc,start=start,count=count,dictArg=dictArg)
        return result

    def Save(self,data):
        result = self.repository.Save(data)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result


if __name__=='__main__':
    pass