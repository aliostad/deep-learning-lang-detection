from cement.core import controller, foundation, handler

from hubmon import fetcher

class BaseController(controller.CementBaseController):
    class Meta:
        label = 'base'

    @controller.expose(aliases=['help'], aliases_only=True)
    def default(self):
        self.app.args.print_help()


def run():
    monitor = foundation.CementApp(
        label='hubmon',
        base_controller = BaseController)
    fetcher.load()
    try:
        monitor.setup()
        monitor.run()
    finally:
        monitor.close()
