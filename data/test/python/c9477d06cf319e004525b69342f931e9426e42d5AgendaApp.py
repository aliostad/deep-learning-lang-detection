'''
Created on Jan 25, 2013

@author: mihai
'''
from Domain.ContactValidator import ContactValidator
from Repository.ContactRepository import ContactRepository
from UI.AgendaController import AgendaController
from UI.AgendaUI import AgendaUI


class AgendaApp:
    """
    Main app class
    """
    
    def __init__(self):
        """
        Constructor method
        """
        self.main()
    
    def main(self):
        """
        This method creates all the necessary objects for the app
        """
        validator = ContactValidator()
        repository = ContactRepository("contacts.dat")
        controller = AgendaController(repository, validator)
        ui = AgendaUI(controller)
        
agendaApp = AgendaApp()