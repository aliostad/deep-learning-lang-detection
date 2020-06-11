'''
Created on 03.02.2013

@author: mihai_000
'''
from Domain.Validator import Validator
from Repository.Repository import Repository
from UI.Console import Console
from UI.Controller import Controller

if __name__ == '__main__':
    transRepository = Repository ("alltranslations.txt")
    #testRepository = Repository ("tests.txt")
    transValidator = Validator()
    transController = Controller (transRepository,transValidator)
    #testController = test_Controller (transRepository,transValidator)
    transConsole = Console (transController)
    transConsole.run()