'''
Created on Dec 2, 2012

@author: mihai
'''
from controller.Controller import LibraryController

class test_controller:
    def __init__(self, bookList, clientList):
        self.__controller = LibraryController(bookList, clientList)
        self.test_addNewBook()
        self.test_updateBook()
#        self.test_removeBook()
        self.test_addNewClient()
        self.test_updateClient()
        self.test_removeClient()
        self.test_lendBook()
        self.test_searchBooks()
        self.test_searchClients()
        self.test_returnBook()
    
    def test_addNewBook(self):
        assert self.__controller.addNewBook("a", "a", "a") == None
        assert self.__controller.addNewBook("b", "b", "b") == None
        
    def test_updateBook(self):
        assert self.__controller.updateBook("a", "a", "a", "b", "1", "1") == True
        assert self.__controller.updateBook("b", "1", "1", "", "", "") == True
        assert self.__controller.updateBook("b", "1", "1", "a", "a", "a") == True
        assert self.__controller.updateBook("b", "1", "1", "a", "a", "a") == False
        
    #def test_removeBook(self):
     #   assert self.__controller.removeBook("b", "b", "b") == True
     #   assert self.__controller.removeBook("b", "b", "b") == False
        
    def test_addNewClient(self):
        assert self.__controller.addNewClient("a", "1") == None
        assert self.__controller.addNewClient("b", "2") == None
        
    def test_updateClient(self):
        assert self.__controller.updateClient("a", "1", "b", "1") == True
        assert self.__controller.updateClient("b", "1", "", "",) == True
        assert self.__controller.updateClient("b", "1", "a", "1") == True
        assert self.__controller.updateClient("b", "1", "a", "1") == False
        
    def test_removeClient(self):
        assert self.__controller.removeClient("b", "2") == True
        assert self.__controller.removeClient("b", "2") == False
        
    def test_searchBooks(self):
        assert self.__controller.searchBooks("nothing") == []
        
    def test_searchClients(self):
        assert self.__controller.searchClients("nothing") == []
        
    def test_lendBook(self):
        assert self.__controller.lendBook("1", "1", "1", "", "") == "book not found"
        assert self.__controller.lendBook("a", "a", "a", "2", "2") == "client not found"
        assert self.__controller.lendBook("a", "a", "a", "a", "1") == True
        assert self.__controller.lendBook("a", "a", "a", "a", "1") == "all books borrowed"
    
    def test_returnBook(self):
        assert self.__controller.returnBook("", "", "", "", "") == "book not found"
        assert self.__controller.returnBook("a", "a", "a", "", "1") == "client not found"
        assert self.__controller.returnBook("a", "a", "a", "a", "1") == True
        assert self.__controller.returnBook("a", "a", "a", "a", "1") == False

    