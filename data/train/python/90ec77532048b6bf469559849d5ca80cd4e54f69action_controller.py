from Menu.menu import Menu
from Menu.text_menu_entry import TextMenuEntry
from Screen.Console.Menu.ActionMenu.action_menu_screen import ActionMenuScreen
from Screen.Console.Menu.ActionMenu.AttackMenu.attack_controller import AttackController
from Screen.Console.Menu.ActionMenu.SwitchMenu.switch_controller import SwitchController

from kao_console.ascii import ENDL, KAO_UP, KAO_DOWN, KAO_LEFT, KAO_RIGHT
from kao_gui.console.console_controller import ConsoleController

class ActionController(ConsoleController):
    """ Controller for selecting a Battle Action """
    
    def __init__(self, pokemon, battle):
        """ Builds the Action Controller """
        self.pokemon = pokemon
        self.battle = battle
        self.action = None
        
        entries = [TextMenuEntry("Fight", self.chooseAttack),
                   TextMenuEntry("Switch", self.switch),
                   TextMenuEntry("Item", None),
                   TextMenuEntry("Run", None)]
        self.menu = Menu(entries, columns=2)
        
        screen = ActionMenuScreen(self.menu, battle)
        cmds = {ENDL:self.menu.enter,
                KAO_UP:self.menu.up,
                KAO_DOWN:self.menu.down,
                KAO_RIGHT:self.menu.right,
                KAO_LEFT:self.menu.left}
                     
        ConsoleController.__init__(self, screen, commands=cmds)
        
    def chooseAttack(self, entry):
        """ Run the Attack Menu Controller """
        attackMenuController = AttackController(self.pokemon, self.battle.oppSide.pkmnInPlay, self.battle)
        self.runController(attackMenuController)
    
    def switch(self, entry):
        """ Run the Switch Menu Controller """
        switchMenuController = SwitchController(self.pokemon)
        self.runController(switchMenuController)
        
    def runController(self, controller):
        """ Runs the given controller """
        ConsoleController.runController(self, controller)
        if controller.action is not None:
            self.action = controller.action
            self.stopRunning()