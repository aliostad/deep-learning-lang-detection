from InputProcessor import commands
from Menu.menu import Menu
from Menu.text_menu_entry import TextMenuEntry

from Screen.Pygame.Menu.ActionMenu.action_menu_widget import ActionMenuWidget
from Screen.Pygame.Menu.ActionMenu.AttackMenu.attack_menu_controller import AttackMenuController
from Screen.Pygame.Menu.ActionMenu.SwitchMenu.switch_menu_controller import SwitchMenuController

from kao_gui.pygame.pygame_controller import PygameController

class ActionMenuController(PygameController):
    """ Controller for Battle Rounds """
    
    def __init__(self, pokemon, battle, screen):
        """ Initialize the Battle Round Controller """
        self.pokemon = pokemon
        self.battle = battle
        self.action = None
        
        entries = [TextMenuEntry("Fight", self.chooseAttack),
                   TextMenuEntry("Switch", self.switch),
                   TextMenuEntry("Item", None),
                   TextMenuEntry("Run", None)]
        self.menu = Menu(entries, columns=2)
        
        self.view = ActionMenuWidget(self.menu, self.getWindow().width*.9, self.getWindow().height*.3)
        screen.setBottomView(self.view)
        cmds = {commands.UP:self.menu.up,
                commands.DOWN:self.menu.down,
                commands.LEFT:self.menu.left,
                commands.RIGHT:self.menu.right,
                commands.SELECT:self.menu.enter}
        PygameController.__init__(self, screen, commands=cmds)
                     
    def chooseAttack(self, entry):
        """ Run the Attack Menu Controller """
        attackMenuController = AttackMenuController(self.pokemon, self.battle.oppSide.pkmnInPlay, self.battle.environment, self.screen)
        self.runController(attackMenuController)
    
    def switch(self, entry):
        """ Run the Switch Menu Controller """
        switchMenuController = SwitchMenuController(self.pokemon)
        self.runController(switchMenuController)
        
    def runController(self, controller):
        """ Runs the given controller """
        PygameController.runController(self, controller)
        if controller.action is None:
            self.screen.setBottomView(self.view)
        else:
            self.action = controller.action
            self.stopRunning()