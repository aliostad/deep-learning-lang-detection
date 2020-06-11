# -*- coding: utf-8 -*-

from app.repository.departmenttype import DepartmentTypeRepository

class DepartmentTypeFacade:
    def __init__(self):
        self.repository = DepartmentTypeRepository()

    def Load(self,id):
        result= self.repository.Load(id=id)
        return result

    def Search(self,id=None,desc=False):
        result = self.repository.Search(id=id,desc=desc)
        return result

    def Save(self,value):
        result = self.repository.Save(value)
        return result

    def Remove(self,id):
        result = self.repository.Remove(id)
        return result


if __name__=='__main__':
    pass