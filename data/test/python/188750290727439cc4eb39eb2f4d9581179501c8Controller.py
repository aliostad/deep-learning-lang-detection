'''
Created on 29.01.2013

@author: mihai_000
'''
from Repository.Repository import RepositoryExport

class Controller:
    
    def __init__(self,agendaRepository):
        self.__agendaRepository = agendaRepository
        
    def addContact(self,id,name,phoneNr,group):
        return self.__agendaRepository.storeContact(id,name,phoneNr,group)
    
    def searchContactByName(self,name):
        for contact in self.__agendaRepository.contactList:
            if contact.getName() == name:
                return contact
        return False

    def searchContactByGroup(self,group):
        contactList = list()
        for contact in self.__agendaRepository.contactList:
            if contact.getGroup() == group:
                contactList.append(contact)
        return contactList
    
    def exportContacts(self,fileName,contacts):
        repositoryExport = RepositoryExport (fileName,contacts)
        return repositoryExport.exportContacts()
    

        