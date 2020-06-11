from nilsson.start_examples.state.model.controller import TurnstileController
from nilsson.start_examples.state.model.state import Locked, Unlocked


class StateMachine:
    def __init__(self, initial_state, controller):
        self.state = initial_state
        self.controller = controller


class TurnstileStateMachine(StateMachine):

    LOCKED = Locked()
    UNLOCKED = Unlocked()

    def coin(self):
        self.state = TurnstileStateMachine.UNLOCKED
        self.controller.coin()

    def turn(self):
        self.state = TurnstileStateMachine.LOCKED
        self.controller.turn()
