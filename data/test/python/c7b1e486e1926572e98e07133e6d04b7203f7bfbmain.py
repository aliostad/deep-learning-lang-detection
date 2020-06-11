#! /usr/bin/env python
# -*- coding: utf-8 -*-

from event_manager import *
from keyboard_controller import *
from game_model import GameModel
from time_controller import TimeController
from game_view import GameView
import pygame

#----------------------------------------------------------------------

def main():

    pygame.init()

    event_manager = EventManager()
    game_model = GameModel(event_manager)
    keyboard_controller = KeyboardController(event_manager)
    time_controller = TimeController(event_manager)
    game_view = GameView(event_manager, game_model, time_controller) # sollte von GameModel aufgemacht werden

    time_controller.run()

#----------------------------------------------------------------------

if __name__ == "__main__":
    main()