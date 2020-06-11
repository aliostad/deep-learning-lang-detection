from pipeline.interface.commandline import CommandlineInterface
from pipeline.level.controller import LevelController
from optparse import OptionParser

import sys

class LevelCommandlineInterface(CommandlineInterface):

    name = "Level"
    
    def make(self, args):

        controller = LevelController()
        controller.make(args)


    def set(self, args):

        controller = LevelController()
        controller.set(args)


    def remove(self, args):

        controller = LevelController()
        controller.remove(args)


    def list(self, args):

        controller = LevelController()
        list_ = controller.list(args)

        self.view = True

        self.levels = list_

