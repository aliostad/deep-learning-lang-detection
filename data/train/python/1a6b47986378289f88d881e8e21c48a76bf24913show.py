from __future__ import print_function

from cement.core import controller
from cement.core import handler

from sandglass.time import __version__


class ShowController(controller.CementBaseController):
    """
    Sandglass CLI command that display sandglass information.

    """
    class Meta:
        label = 'show'
        interface = controller.IController
        description = "Show sandglass information"
        stacked_on = 'base'
        stacked_type = 'nested'

    @controller.expose(help="display sandglass version")
    def version(self):
        print("Sandglass", __version__)


handler.register(ShowController)
