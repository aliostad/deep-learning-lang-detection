'''
Created on 23.02.2013

@author: mihai_000
'''
from Domain.Validator import Validator
from Repository.Repository import Repository
from UI.Console import Console
from UI.Controller import Controller, test_Controller

if __name__ == '__main__':
    transRepository = Repository ("dictionary.txt")
    testRepository = Repository ("test.txt")
    transValidator = Validator()
    transController = Controller (transRepository,transValidator)
    testController = test_Controller (testRepository,transValidator)
    transConsole = Console (transController)
    transConsole.run()