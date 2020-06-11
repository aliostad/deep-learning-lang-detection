from Menu.OptionsMenu.options_menu import OptionsMenu
from Screen.Console.Menu.OptionsMenu.options_menu_screen import OptionsMenuScreen

from kao_gui.console.console_controller import ConsoleController

class OptionsMenuController(ConsoleController):
    """ Controller for the options menu """
    
    def __init__(self):
        """ Builds the Options Menu Controller """
        self.menu = OptionsMenu()
        screen = OptionsMenuScreen(self.menu)
        
        ConsoleController.__init__(self, screen, cancellable=True)