

def singleton(klass):
    return klass()


def transition(new_state):
    def called_on(fn):
        transitions = getattr(fn, 'state_transitions', [])
        if isinstance(new_state, basestring):
            transitions.append(new_state)
        elif isinstance(new_state, type):
            transitions.append(new_state.__name__)
        elif isinstance(type(new_state), type):
            transitions.append(new_state.__class__.__name__)
        else:
            raise Exception('Unsupported type {0}'.format(new_state))
        setattr(fn, 'state_transitions', transitions)
        return fn
    return called_on


class State(object):

    def start(self, controller):
        pass

    def end(self, controller):
        pass

    def mouseOut(self, controller):
        pass

    def mousePressed(self, controller):
        pass

    def mouseReleased(self, controller):
        pass


class Controller(object):

    def __init__(self):
        self.state = None

    def changeState(self, state):
        if self.state:
            self.state.end(self)
        self.state = state
        if self.state:
            self.state.start(self)


@singleton
class NotPressed(State):

    @transition('Pressed')
    def mousePressed(self, controller):
        controller.changeState(Pressed)


@singleton
class Clicked(State):

    @transition('NotPressed')
    def start(self, controller):
        if controller.call_back:
            controller.call_back(controller)
        controller.changeState(NotPressed)


@singleton
class Pressed(State):

    def start(self, controller):
        controller.pressed = True

    def end(self, controller):
        controller.pressed = False

    @transition('Clicked')
    def mouseReleased(self, controller):
        controller.changeState(Clicked)

    @transition('NotPressed')
    def mouseOut(self, controller):
        controller.changeState(NotPressed)
