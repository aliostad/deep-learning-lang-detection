from View.Console.Game.player_turn_controller import PlayerTurnController

from kao_gui.console.console_controller import ConsoleController

class RoundController(ConsoleController):
    """ Controller for running a Round of the Game """
    
    def __init__(self, game):
        """ Initialize the Round Controller """
        self.game = game
        ConsoleController.__init__(self, None)
        
    def run(self):
        """ Run a single round of the chess game """
        self.running = True
        
        for player in self.game.players:
            self.runPlayerTurn(player)
            if self.game.over:
                return
                
    def runPlayerTurn(self, player):
        """ Run the Player's Turn """
        self.runController(PlayerTurnController(player, self.game))