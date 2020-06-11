#!/usr/bin/env python

from cement.core import foundation, controller, handler


class SkylerBaseController(controller.CementBaseController):
    class Meta:
        label = 'base'
        description = 'Skyler CLI: PaaS on OpenStack'

    @controller.expose(hide=True)
    def default(self):
        self.app.args.print_help()


class Skyler(foundation.CementApp):
    class Meta:
        label = 'skyler-cli'
        base_controller = SkylerBaseController


def main():
    from application import ApplicationListController, ApplicationCreationController, ApplicationBuildController, \
        ApplicationHistoryController, ApplicationSpinUpController, ApplicationHaltController
    from db import InitDBController

    app = Skyler('skyler')
    handler.register(ApplicationListController)
    handler.register(ApplicationCreationController)
    handler.register(InitDBController)
    handler.register(ApplicationBuildController)
    handler.register(ApplicationHistoryController)
    handler.register(ApplicationSpinUpController)
    handler.register(ApplicationHaltController)
    try:
        app.setup()
        app.run()
    finally:
        app.close()


if __name__ == "__main__":
    main()
