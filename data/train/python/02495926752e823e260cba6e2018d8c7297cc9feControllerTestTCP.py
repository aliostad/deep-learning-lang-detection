'''
Created on Dec 14, 2013

@author: root
'''
import unittest
from domain.Controller import Controller
from domain.Commander import Commander
from domain.CustomTCPServer import CustomTCPServer

class Test(unittest.TestCase):


    def testCommandInput(self):
        server = CustomTCPServer('0.0.0.0', 555)
        server.startServer()
        controller = Controller(Commander(server))
        
        controller.waitAction()
        controller.waitAction()
        controller.waitAction()

if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testCommandInput']
    unittest.main()