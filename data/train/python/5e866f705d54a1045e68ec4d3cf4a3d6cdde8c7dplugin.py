from hatak.plugin import Plugin
from hatak.controller import ControllerPlugin

from .helpers import MenuWidget


class MenuPlugin(Plugin):

    def add_controller_plugins(self):
        self.add_controller_plugin(MenuControllerPlugin)


class MenuControllerPlugin(ControllerPlugin):

    def make_helpers(self):
        try:
            self.add_helper(
                'menu', MenuWidget, self.controller.menu_highlighted)
        except AttributeError:
            # if no menu_highlighted is avalible, it means no menu will be
            # needed
            pass
