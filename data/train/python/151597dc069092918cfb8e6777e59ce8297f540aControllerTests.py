'''
Created on Jan 25, 2013

@author: mihai
'''
from Domain.ContactValidator import ContactValidator
from Repository.ContactRepository import ContactRepository
from UI.AgendaController import AgendaController

def testController():
    file = open("repoTest2.dat", "w")
    file.close()
    repo = ContactRepository("repoTest2.dat")
    validator = ContactValidator()
    controller = AgendaController(repo, validator)
    assert controller.addContact(1, "name", "1234", "Family") == None
    assert "Phone number must only contain digits" in controller.addContact(1, "name", "123a", "Family")
    assert controller.lookup("name") == "1234"
    assert controller.lookup("nobody") == False
    assert controller.lookupAll("Family")[0].getName() == "name"
    controller.exportCSV("Family", "CSVTest.dat")
    csv = open("CSVTest.dat", "r")
    assert csv.readline() != ""