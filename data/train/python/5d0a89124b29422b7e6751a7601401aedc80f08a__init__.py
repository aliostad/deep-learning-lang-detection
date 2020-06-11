import sys
import time
import argparse
from .pages import diff, log, branches
from . import gridcontroller
import gitgrid.utils.utils


class PageManager(object):
    def __init__(self, controller):
        self.controller = controller

        self.controller.actions['tab1'] = self.switchto
        self.controller.actions['tab2'] = self.switchto
        self.controller.actions['tab3'] = self.switchto
        self.controller.actions['tab4'] = self.switchto

        self.pages = {
            'tab1': diff.Diff(controller),
            'tab2': log.Log(controller),
            'tab3': branches.Branches(controller),
        }

        self.refreshevent = None
        self.switchto('tab1', None)

    def switchto(self, action, message):
        self.active = action
        self.pages[self.active].activate()

    def refresh(self):
        self.pages[self.active].draw()


def main(inargs=None):
    args = gitgrid.utils.utils.controller_args()

    sys.stdout = gitgrid.utils.utils.Unbuffered(sys.stdout)
    controller = gridcontroller.create(args.controller, args.input, args.output)
    manager = PageManager(controller)
    controller.loop()


if __name__ == "__main__":
    main(sys.args)
