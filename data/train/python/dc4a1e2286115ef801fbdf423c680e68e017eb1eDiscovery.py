'''
Created on Jul 15, 2014

@author: P.Suman
'''
from BaseClass import TestBase
import globalVars

class Testcase(TestBase): 
    
    def __init__(self):
        TestBase.__init__(self)
    
    def test_discovery(self):
        response = self.discoverServer()
        discStatus = self.verifyDiscoveryStatus(response)                
        print self.manageDevice(discStatus)
        #print self.manageNetworks()
        #self.manageNetworks()


if __name__ == "__main__":
    test = Testcase()
    test.test_discovery()
