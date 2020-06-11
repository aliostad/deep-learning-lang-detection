import pygame
import sys
import time
from intro_controller import IntroController
from settings import RESOLUTION

from spacebar_controller import SpacebarController, LONGPRESS, SHORTPRESS
from game_controller import ControllerResignException
from gameplay_controller import GameplayController
from outro_controller import OutroController

class GameControllerManager(object):

    def __init__(self, controllers):
        self.controllers = controllers
        args = controllers[0][1]
        constructor = controllers[0][0]
        self.active_controller = constructor(*args)
        self.active_controller_index = 0

    def next_controller(self):
        if self.active_controller_index < len(self.controllers) - 1:
            self.active_controller_index += 1
        else:
            self.active_controller_index = 0
        args = self.controllers[self.active_controller_index][1]
        constructor = self.controllers[self.active_controller_index][0]
        self.active_controller = constructor(*args)


def init_game():
    window = pygame.display.set_mode(RESOLUTION)
    pygame.display.set_caption("Pirate Squirrel")
    screen = pygame.display.get_surface()
    return window, screen


def mainloop(screen, started_at):
    # we need to transform all events from

    sc = SpacebarController()

    game_controllers = [
 #       (IntroController, (screen,)),
 #       (GameplayController, (screen,)),
        (OutroController, (screen,)),
    ]
    cm = GameControllerManager(game_controllers)

    while True:
        current_time = time.time()
        time_elapsed = 1000 * (current_time - started_at)
        event = sc.tick(time_elapsed)

        if event == LONGPRESS:
            cm.active_controller.longpress()
        elif event == SHORTPRESS:
            cm.active_controller.shortpress()
        try:
            cm.active_controller.update(time_elapsed)
            cm.active_controller.draw()
        except ControllerResignException:
            cm.next_controller()
            pygame.display.flip()
            cm.active_controller.draw()
        pygame.display.flip()


if __name__ == "__main__":
    window, screen = init_game()
    start_time = time.time()
    mainloop(screen, start_time)
    sys.exit(0)
