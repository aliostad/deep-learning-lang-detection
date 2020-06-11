from Level.level import Level

from View.Console.controller import Controller
from View.Console.Level.level_view import LevelView
from View.Console.Level.Infection.infection_controller import InfectionController
from View.Console.Level.Player.player_action_controller import PlayerActionController
from View.Console.Level.Player.player_draw_controller import PlayerDrawController

class LevelController(Controller):
    """ Controller for the level """
    
    def __init__(self):
        """ Initialize the Level Controller """
        self.level = Level()
        Controller.__init__(self, LevelView(self.level))
        self.gameLoopActionIndex = 0
            
    def performGameCycle(self):
        """ Perform a Game Cycle Event """
        gameLoopActions = [self.doPlayerActions, self.drawPlayerCard, self.drawPlayerCard, self.infectACity, self.infectACity]
        gameLoopActions[self.gameLoopActionIndex]()
        self.gameLoopActionIndex += 1
        self.gameLoopActionIndex %= len(gameLoopActions)
        
    def handleInput(self):
        """ Do Nothing """
                
    def doPlayerActions(self):
        """ Perform Player Actions """
        player = self.level.players[0]
        
        controller = PlayerActionController(self.level, player)
        controller.run()
        
        if controller.quitting:
            self.stopRunning()
        
    def infectACity(self):
        """ Infect a City """
        infectedCity = self.level.infectionDeck.draw()
        if infectedCity is not None:
            controller = InfectionController(infectedCity)
            controller.run()
            
    def drawPlayerCard(self):
        """ Draw a card for the current player """
        player = self.level.players[0]
        card = self.level.playerDeck.draw()
        if card is not None:
            controller = PlayerDrawController(player, card)
            controller.run()