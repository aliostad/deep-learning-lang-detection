"""
All button and tab command objects.

Each object has a 'do' method that takes no parameters. Any necessary parameter
should be passed in upon initialization.
"""

import pygame

#-----------Machine Commands---------------------------------------------------

class ControllerCommand(object):
    """ base class for commands on controller """
    
    def __init__(self, controller):
        self.controller = controller
        
    def do(self):
        pass
        
class LeftCommand(ControllerCommand):
    def do(self):
        self.controller.jog_left()

class RightCommand(ControllerCommand):
    def do(self):
        self.controller.jog_right()
        
class TowardCommand(ControllerCommand):
    def do(self):
        self.controller.jog_toward()
        
class AwayCommand(ControllerCommand):
    def do(self):
        self.controller.jog_away()
        
class GoCommand(ControllerCommand):
    def do(self):
        self.controller.mill_board()

class PauseCommand(ControllerCommand):
    def do(self):
        self.controller.pause_board()

class ResetCommand(ControllerCommand):
    def do(self):
        self.controller.reset_board()

class UpCommand(ControllerCommand):
    def do(self):
        self.controller.pen_up()

class DownCommand(ControllerCommand):
    def do(self):
        self.controller.jog_down()

class CutCommand(ControllerCommand):
    def do(self):
        self.controller.pen_cut()


#-----------GUI Commands-------------------------------------------------------
    
class SelectTab(object):
    """ job board right """
    
    def __init__(self, tabbed_pane, tab):
        self.tabbed_pane = tabbed_pane
        self.tab = tab
        
    def do(self):
        self.tabbed_pane.select_tab(self.tab)
        self.tabbed_pane.draw()
        pygame.display.flip()
    