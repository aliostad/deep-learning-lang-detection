'''
Created on 10 nov. 2014

@author: Narcis2007
'''
from aplicatie.domain.entitati import ProblemaLaborator
from aplicatie.repository.repository_plab import RepositoryPLab, EroareID
import unittest
from unittest.suite import TestSuite
'''
class TestRepositoryPLab:
    def __init__(self):
        self.__repository=RepositoryPLab()
        p1=ProblemaLaborator(1,1,"w","t")
        p2=ProblemaLaborator(2,2,"t","y")
        p3=ProblemaLaborator(3,3,"g","h")
        self.__repository.save(p1)
        self.__repository.save(p2)
        self.__repository.save(p3)
    
    def test_save(self):
        try:
            p1=ProblemaLaborator(1,1,"w","t")
            self.__repository.save(p1)
            assert False
        except EroareID:
            assert True
            
    def test_lungime(self):
        assert self.__repository.lungime()==3
    
    def test_delete(self):
        self.__repository.delete(11)
        assert self.__repository.lungime()==2
        try:
            self.__repository.delete(11)
            assert False
        except EroareID:
            assert True
    def test_find(self):
        p=self.__repository.find(22)
        p2=ProblemaLaborator(2,2,"t","y")
        assert p==p2
    
    def test_update(self):
        p2=ProblemaLaborator(2,2,"t","y")
        self.__repository.update(p2)
        p=self.__repository.find(22)
        assert p2==p
        try:
            p2=ProblemaLaborator(2,3,"r","b")
            self.__repository.update(p2)
            p=self.__repository.find(33)
            assert False
        except EroareID:
            assert True
        
    def test_get_all(self):
        l=self.__repository.get_all()
        assert len(l)==2
        
    def test_repository_plab(self):
        self.test_save()
        self.test_lungime()
        self.test_delete()
        self.test_find()
        self.test_update()
        self.test_get_all()
'''
class TestRepositoryPlab(unittest.TestCase):
    def setUp(self):
        self.__repository=RepositoryPLab()
        p1=ProblemaLaborator(1,1,"w","t")
        p2=ProblemaLaborator(2,2,"t","y")
        p3=ProblemaLaborator(3,3,"g","h")
        self.__repository.save(p1)
        self.__repository.save(p2)
        self.__repository.save(p3)
    
    def test_save(self):
        p1=ProblemaLaborator(1,1,"w","t")
        self.assertRaises(EroareID,lambda: self.__repository.save(p1))
            
    def test_lungime(self):
        assert self.__repository.lungime()==3
    
    def test_delete(self):
        self.__repository.delete(11)
        assert self.__repository.lungime()==2
        self.assertRaises(EroareID, lambda:self.__repository.delete(11))

    def test_find(self):
        p=self.__repository.find(22)
        p2=ProblemaLaborator(2,2,"t","y")
        assert p==p2
    
    def test_update(self):
        p2=ProblemaLaborator(2,2,"t","y")
        self.__repository.update(p2)
        p=self.__repository.find(22)
        assert p2==p
        p2=ProblemaLaborator(2,3,"r","b")
        self.assertRaises(EroareID, lambda:self.__repository.update(p2))
        
    def test_get_all(self):
        l=self.__repository.get_all()
        assert len(l)==3 
def suite():
    suite=unittest.TestSuite()
    suite.addTest(unittest.TestLoader().loadTestsFromTestCase(TestRepositoryPlab))
    return suite