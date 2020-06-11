'''
Created on 13 nov. 2014

@author: Narcis2007
'''
from aplicatie.repository.repository_plab import RepositoryPLab
from aplicatie.controller.controller_plab import ControllerPLab
from aplicatie.domain.entitati import ProblemaLaborator
from aplicatie.domain.validatori import ValidatorPlab
import unittest
'''
class TestControllerPLab:
    def __init__(self):
        self.__repository=RepositoryPLab()
        self.__controller=ControllerPLab(self.__repository,ValidatorPlab())
        p1=ProblemaLaborator(1,1,"q","marti")
        p2=ProblemaLaborator(2,2,"w","miercuri")
        p3=ProblemaLaborator(3,3,"t","y")
        self.__repository.save(p1)
        self.__repository.save(p2)
        self.__repository.save(p3)
        
    def test_adauga_problema(self):
        assert self.__repository.lungime()==3
        self.__controller.adauga_problema(4,4,"u", "r")
        assert self.__repository.lungime()==4
            
    def test_sterge_problema(self):
        self.__controller.stergere_problema(11)
        assert self.__repository.lungime()==3
    
    def test_modifica_problema(self):
        self.__controller.modifica_problema(2, 2, "descriere", "deadline")
        p=ProblemaLaborator(2, 2, "descriere", "deadline")
        p1=self.__repository.find(22)
        assert p1==p
    
    def test_cauta(self):
        p=ProblemaLaborator(2,2, "descriere", "deadline")
        assert self.__controller.cauta_problema(22)==p
        
    
    def test_get_all(self):
        l=self.__controller.get_all()
        assert len(l)==3
            
    def test_controller_plab(self):
        self.test_adauga_problema()
        self.test_sterge_problema()
        self.test_modifica_problema()
        self.test_cauta()
        self.test_get_all()
'''
class TestControllerPLab(unittest.TestCase):
    def setUp(self):
        self.__repository=RepositoryPLab()
        self.__controller=ControllerPLab(self.__repository,ValidatorPlab())
        p1=ProblemaLaborator(1,1,"q","marti")
        p2=ProblemaLaborator(2,2,"w","miercuri")
        p3=ProblemaLaborator(3,3,"t","y")
        self.__repository.save(p1)
        self.__repository.save(p2)
        self.__repository.save(p3)
        
    def test_adauga_problema(self):
        assert self.__repository.lungime()==3
        self.__controller.adauga_problema(4,4,"u", "r")
        assert self.__repository.lungime()==4
            
    def test_sterge_problema(self):
        self.__controller.stergere_problema(11)
        assert self.__repository.lungime()==2
    
    def test_modifica_problema(self):
        self.__controller.modifica_problema(2, 2, "descriere", "deadline")
        p=ProblemaLaborator(2, 2, "descriere", "deadline")
        p1=self.__repository.find(22)
        assert p1==p
    
    def test_cauta(self):
        p=ProblemaLaborator(2,2,"w","miercuri")
        assert self.__controller.cauta_problema(22)==p
        
    def test_get_all(self):
        l=self.__controller.get_all()
        assert len(l)==3
        
def suite():
    suite=unittest.TestSuite()
    suite.addTest(unittest.TestLoader().loadTestsFromTestCase(TestControllerPLab))
    return suite