from View.Console.controller import Controller
from View.Console.Level.Infection.infection_view import InfectionView

from kao_console.ascii import *

class InfectionController(Controller):
    """ Controller for an Infection """
    
    def __init__(self, city):
        """ Initialize the Infection Controller """
        Controller.__init__(self, InfectionView(city))
        self.city = city
        self.infected = False
        
        self.commands = {}
        self.addCommand(ENDL, self.stopRunning)
        
    def performGameCycle(self):
        """ Perform a Game Cycle Event """
        if not self.infected:
            self.city.infect(1)
            self.infected = True
            