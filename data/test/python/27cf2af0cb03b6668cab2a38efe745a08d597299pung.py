# -*- coding: utf-8 -*-
import pygame
import controllers
import views
from event_manager import event_manager

def main():
    """
    Behold! Here happens The Main Shit.

    """
    pygame.init()
    # initialize controllers
    view_controller = controllers.ViewController()
    player_controller = controllers.PlayerController()
    loop = controllers.LoopController()
    event_manager.register_listener(view_controller)
    event_manager.register_listener(player_controller)
    event_manager.register_listener(loop)

    # initialize views
    menu_view = views.MenuView()
    event_manager.register_listener(menu_view)

    # start master loop
    loop.run()

    pygame.quit()

if __name__ == '__main__':
    main()
