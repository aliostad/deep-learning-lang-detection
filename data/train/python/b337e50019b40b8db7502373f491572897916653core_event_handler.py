from Battle.battle_message import BattleMessage
from Pokemon.LevelEvents.learn_attack_event import LearnAttackEvent

from Screen.Pygame.Event.LearnAttack.learn_attack_controller import LearnAttackController
from Screen.Pygame.MessageBox.message_box_controller import MessageBoxController

def PerformEvents(eventQueue, controller):
    """ Perform the given events """
    while len(eventQueue) > 0:
        event = eventQueue.popleft()
        PerformEvent(event, controller)

def PerformEvent(event, controller):
    """ Perform the given event """
    eventController = None
    
    if isinstance(event, str):
        eventController = MessageBoxController(BattleMessage(event), controller.screen)
    elif isinstance(event, LearnAttackEvent):
        eventController = LearnAttackController(event, controller.screen)
        
    if eventController is not None:
        controller.runController(eventController)