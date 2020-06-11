from View.Console.Game.Setup.game_setup_screen import GameSetupScreen
from View.Console.Game.Setup.player_name_controller import PlayerNameController

from kao_gui.console.console_controller import ConsoleController

class GameSetupController(ConsoleController):
    """ Controller for Game Setup """
    
    def __init__(self):
        """ Initialize the Game Setup Controller """
        self.playerCount = 0
        self.names = []
        screen = GameSetupScreen()
        ConsoleController.__init__(self, screen, commands={'1':self.setPlayerCount,
                                                           '2':self.setPlayerCount,
                                                           '3':self.setPlayerCount,
                                                           '4':self.setPlayerCount,
                                                           '5':self.setPlayerCount,
                                                           '6':self.setPlayerCount})
        
    def setPlayerCount(self, event):
        """ Set the player Count """
        self.playerCount = int(event)
        
        for i in range(self.playerCount):
            controller = PlayerNameController()
            self.runController(controller)
            if controller.name != "":
                self.names.append(controller.name)
            
        self.stopRunning()