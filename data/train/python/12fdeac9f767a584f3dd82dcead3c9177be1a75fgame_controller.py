from View.Console.Game.game_screen import GameScreen
from View.Console.Game.round_controller import RoundController

from kao_console.ascii import ENDL
from kao_gui.console.console_controller import ConsoleController

class GameController(ConsoleController):
    """ Controller for running a game of Chess """
    
    def __init__(self, game):
        """ Initialize the Game Controller """
        self.game = game
        screen = GameScreen()
        ConsoleController.__init__(self, screen, commands={ENDL:self.nextMessage})
        
    def nextMessage(self, event):
        """ Tell the screen to print the next message """
        while not self.game.over:
            self.runController(RoundController(self.game))
        self.stopRunning()