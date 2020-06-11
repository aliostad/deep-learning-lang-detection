from InputProcessor import commands

from Menu.TrainerMenu.trainer_menu import TrainerMenu
from Screen.Pygame.Battle.battle_controller import BattleController
from Screen.Pygame.Menu.TrainerMenu.trainer_menu_screen import TrainerMenuScreen
from Screen.Pygame.Marathon.marathon_controller import MarathonController
from Screen.Pygame.Zone.zone_controller import ZoneController

from Trainer.trainer_factory import TrainerFactory

from kao_gui.pygame.pygame_controller import PygameController

class TrainerMenuController(PygameController):
    """ Controller for the trainer select menu """
    
    def __init__(self):
        """ Builds the Main Menu Controller """
        self.menu = TrainerMenu(self.performBattle)
        screen = TrainerMenuScreen(self.menu)
        cmds = {commands.UP:self.menu.up,
                commands.DOWN:self.menu.down,
                commands.EXIT:self.stopRunning,
                commands.SELECT:self.menu.enter}
        PygameController.__init__(self, screen, commands=cmds)
                     
    def performBattle(self, entry):
        """ Perform a Battle """
        # enemy = TrainerFactory.loadFromXML("Badass", "Eric", TrainerFactory.COMPUTER)
        # battleController = BattleController(entry.trainer, enemy)
        # battleController.run()
        # zoneController = ZoneController(entry.trainer)
        # zoneController.run()
        self.runController(MarathonController(entry.trainer))
        # marathonController = MarathonController(entry.trainer)
        # marathonController.run()
        
    # def exit(self):
        # """ Return if the controller is still running """
        # return self.stopRunning()