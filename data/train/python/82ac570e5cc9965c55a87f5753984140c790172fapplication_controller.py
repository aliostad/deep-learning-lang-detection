# application_controller.py
# description: this is the main controller object with all other controller objects under it
#
# ApplicationController*
#     IntroController
#     MainController
#         LeftNavController
#         MainNavController
#         MapNavController


from Models.config import *
from Models.game import *
from Views.main_view import *
from Controllers.main_controller import *
from Controllers.intro_controller import *


class ApplicationController(object):
    def __init__(self):

        # save config
        self.conf = ConfigFile()

        # build main controller to handle main screen requests
        self.main_controller = MainController(self)
        # self.main_controller.parent = self

        self.game = None

    def debug(self, message):
        if self.conf.debug == 1:
            print message

    def debug_messaging(self, message):
        if self.conf.debug_messaging == 1:
            print message

    def new_game(self):
        self.game = Game(self)


def add_unique(array, item):

    # replace this function using x in array_of_x if/then statement, python is probably more efficient than I am :)

    in_array = False
    for i in array:
        if i == item:
            in_array = True

    if not in_array:
        array.append(item)

    return array