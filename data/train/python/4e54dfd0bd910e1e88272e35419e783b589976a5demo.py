
from datetime import timedelta

class DemoApp(object):
    def __init__(self):
        self._controllers = []
        self._time = timedelta(0)
        self._timeout = timedelta(seconds=5)

    def add_controller(self, controller):
        self._controllers.append(controller)

    def run(self, time_delta):
        controller = self._controllers[0]
        if controller.reached_goal:
            self._time += time_delta
            if self._time > self._timeout:
                controller.goal = (-5, -5)
                controller.set_current_controller(0)

    def set_goal(self, goal):
        controller = self._controllers[0]
        controller.set_current_controller(2)
        controller.goal = goal
        controller.reached_goal = False
        self._time = timedelta(0)
