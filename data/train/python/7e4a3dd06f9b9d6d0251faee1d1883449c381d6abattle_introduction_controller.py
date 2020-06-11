from InputProcessor import commands
from Screen.Pygame.Event.core_event_handler import PerformEvents

from kao_gui.pygame.pygame_controller import PygameController

class BattleIntroductionController(PygameController):
    """ Controller for Battle Introductions """
    
    def __init__(self, battle, screen):
        """ Initialize the Battle Introduction Controller """
        self.battle = battle
        PygameController.__init__(self, screen)
        
    def performGameCycle(self):
        """ Tells the battle object what to perform """
        PerformEvents(self.battle.eventQueue, self)
        self.stopRunning()