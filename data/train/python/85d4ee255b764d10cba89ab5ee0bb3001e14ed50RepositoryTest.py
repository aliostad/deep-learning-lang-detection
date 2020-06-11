'''
Created on Sep 11, 2014

@author: drury
'''
import unittest
from CA01.prod import Repository as repository
from CA01.prod import Component as component

class RepositoryTest(unittest.TestCase):

    '''
    Class created to test the Repository class
    '''

    def setUp(self):
        self.testRepository = repository.Repository(2)
        
    def testInstantiateRep200(self):
        # test the creation of a repository with capacity=200
        testRepository = repository.Repository(200)    
    
    def testGetNumberComponents(self):
        #print self.testRepository.count() 
        #print self.testRepository.getCapacity()
        return self.testRepository.count()
    
    def testRepositoryNoParam(self):
        # test the creation of a repository without parameter
        self.testRepository = repository.Repository()
        #print self.testRepository.count()
        #print self.testRepository.getCapacity()
        
    def testRepositoryCap2(self):
        # test the creation of a repository with capacity=2
        self.testRepository = repository.Repository(2)
        #print self.testRepository.count()
        #print self.testRepository.getCapacity()
        
    def testAddComponent(self):
        # test the addition of a component
        self.testRepository = repository.Repository(2)
        C1 = component.Component("C1",4,20)
        self.testRepository.addComponent(C1)
        # print self.testRepository.count()
        # print self.testRepository.getCapacity()
        
    
        
    def testExceptionCapacity0(self):
        #Exception if the capacity is 0
        expectedString = "Repository.__init__: The capacity needs to be grand than 0"        
        try:
            testRepository = repository.Repository(0)
            self.fail("exception was not raised")
        except ValueError as raisedException:
            diagnosticString = raisedException.args[0]
            self.assertEquals(expectedString, diagnosticString[0:len(expectedString)])
        except:
            self.fail("incorrect exception was raised")    
    
    def testCompleteRepository2(self):
        C2 = component.Component("C2",4,40)
        C3 = component.Component("C3",1,20)
        self.testRepository.addComponent(C2)
        self.testRepository.addComponent(C3)
        #CC1= self.testRepository.repository.pop()
        #CC2= self.testRepository.repository.pop()
        #print CC2.getName()
        #print CC1.getName()
        #print self.testRepository.count()
        #print self.testRepository.getCapacity()
        
    def testValidCountRepository(self):
        #test valid count of components in the repository
        C2 = component.Component("C2",4,40)
        C3 = component.Component("C3",1,20)
        self.testRepository.addComponent(C2)
        self.testRepository.addComponent(C3)
        #print self.testRepository.validCount()
        return self.testRepository.validCount()
    
    def testExceptionAddComponentNoParam(self):
        #Exception if the parameter is missing
        expectedString = "Repository.addComponent: The method addComponent needs a parameter"        
        try:
            self.testRepository.addComponent()
            self.fail("exception was not raised")
        except ValueError as raisedException:
            diagnosticString = raisedException.args[0]
            self.assertEquals(expectedString, diagnosticString[0:len(expectedString)])
        except:
            self.fail("incorrect exception was raised")
    
    
    
        
    def testRelativeSizes(self):
        #test the relative sizes of the components in the repository
        self.testRepository = repository.Repository(5)
        component1 = component.Component(name="Component01",methodCount=1,locCount=76)
        component2 = component.Component("Component02",locCount=116,methodCount=4)
        component3 = component.Component("Component03",7,locCount=113)
        component4 = component.Component("Component04",5,103)
        component5 = component.Component("Component5",0,10)
        self.testRepository.addComponent(component1)
        self.testRepository.addComponent(component2)
        self.testRepository.addComponent(component3)
        self.testRepository.addComponent(component4)
        self.testRepository.addComponent(component5)
        
        relativeSizes = self.testRepository.determineRelativeSizes()
        #print relativeSizes

    

if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()