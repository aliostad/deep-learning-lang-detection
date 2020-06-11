#!/usr/bin/env python3
from cement.core import foundation, controller, handler
from cement.core.controller import CementBaseController, expose

# define application controllers


class DemoPlugin4eeController(CementBaseController):

    class Meta:
        label = 'DemoPlugin4ee'
        description = "Demo Plugin for ee"
        stacked_on = 'base'
        stacked_type = 'embedded'
        arguments = [
            (['--foo'], dict(help="option under base controller")),

        ]

    @expose(help="another base controller command")
    def eeplugn1(self):
        print("Inside DemoPlugin4eeController.eeplugn1()")


def load(ee):
    handler.register(DemoPlugin4eeController)
