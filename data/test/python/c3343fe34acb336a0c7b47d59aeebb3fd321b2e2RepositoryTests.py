'''
Created on Jan 25, 2013

@author: mihai
'''
from Domain.Contact import Contact
from Repository.ContactRepository import ContactRepository

def testRepository():
    file = open("repoTest.dat", "w")
    file.close()
    repo = ContactRepository("repoTest.dat")
    contact = Contact(2, "new", "12351251", "Family")
    repo.add(contact)
    
    repo = ContactRepository("repoTest.dat")
    assert repo.find("new") == "12351251"
    assert repo.getAllFor("Family")[0].getName() == "new"
    assert repo.getAll()[0].getName() == "new"