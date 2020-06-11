# import sqlite3
from cement.core import backend, foundation, controller, handler

from database import Db, Show


class BaseController(controller.CementBaseController):
    class Meta(object):
        label = 'base'
        description = 'ShowPy manages your shows.'

    def _setup(self, base_app):
        super(BaseController, self)._setup(base_app)

    @controller.expose(hide=True)
    def default(self):
        app.args.print_help()

    @controller.expose(aliases=['ls', 'l'], help='Print the show list.')
    def list(self):
        print self.shows

    @controller.expose(help='Show help.')
    def help(self):
        app.args.print_help()


class AddShowController(controller.CementBaseController):
    class Meta(object):
        aliases = ['add', 'a']
        label = 'add_show'
        description = 'Add a show to the collection'
        stacked_on = 'base'
        stacked_type = 'nested'
        arguments = [
            (['show'], dict(nargs='+')),
            ]


class ShowPy(foundation.CementApp):
    class Meta(object):
        label = 'showpy'
        base_controller = BaseController


app = ShowPy()
handler.register(AddShowController)

def main():
    db = Db.instance()
    try:
        app.setup()
        app.run()
    finally:
        # close the app
        app.close()


if __name__ == '__main__':
    main()