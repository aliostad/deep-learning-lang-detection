import pygame

import models.Config as config

def getController():
    global __current
    return __current

def setController(controller):
    global __current
    __current = controller
    return controller

class BaseController(object):
    TICK_TIME = config.TICK_TIME

    def __init__(self):
        self.screen = pygame.display.get_surface()
        self.clock = pygame.time.Clock()
        self.background = pygame.Surface(self.screen.get_size())

        self.quit = False
        self.nextController = False

    def run(self):
        raise Exception("Run function not implemented.")
