from InputProcessor import commands
from Marathon.marathon import Marathon

from Screen.Pygame.Marathon.marathon_screen import MarathonScreen
from Screen.Pygame.Zone.zone_controller import ZoneController

from kao_gui.pygame.pygame_controller import PygameController

class MarathonController(PygameController):
    """ Controller for a Marathon """
    
    def __init__(self, trainer):
        """ Initialize the Marathon Controller """
        self.marathon = Marathon()
        self.trainer = trainer
        screen = MarathonScreen(self.marathon)
        
        cmds = {commands.SELECT:self.select,
                commands.EXIT:self.stopRunning}
        PygameController.__init__(self, screen, commands=cmds)
                     
    def select(self):
        """ Performs a Select """
        if self.marathon.beaten():
            self.stopRunning()
        else:
            zone = self.marathon.loadZone()
            self.runController(ZoneController(self.trainer, zone, 1, 2, doneCallback=self.marathon.beaten))