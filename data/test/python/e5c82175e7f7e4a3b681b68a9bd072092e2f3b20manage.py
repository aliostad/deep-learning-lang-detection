from cement.core import controller

from decanter import app, cli
from decanter.admin import create_app
from decanter.cli import InstallDBController, CreateRoleController, CreateUserController


class RootController(cli.RootController):
    class Meta:
        label = 'base'
        description = "Management tools for decanter based website."


class ServerController(cli.ServerController):
    flask_app = app


# TestController currently not implemented
class TestController(cli.Controller):

    class Meta:
        label = 'tests'
        description = "Run the decanter test suite"

    @controller.expose(hide=True, help='Run the decanter test suite')
    def default(self):
        #test.run('tests')
        pass


class AssetController(cli.Controller):

    class Meta:
        label = 'assets'
        description = "Build, watch or clean static assets"
        arguments = [
            (['-b', '--bundle'], {
                'action': 'append',
                'help': 'Build bundle asset',
                'default': [],
            }),
            (['-f', '--force'], {
                'action': 'store_true',
                'help': 'Force build even if it exists',
            })
        ]

    @controller.expose(hide=True, help='Build, watch or clean static assets')
    def default(self):
        self.app.args.print_help()

    @controller.expose(help='Build static assets')
    def build(self):
        args = ['build'] + self.pargs.bundle
        self.run(*args)

    @controller.expose(help='Rebuild static assets')
    def rebuild(self):
        args = ['build', '--no-cache'] + self.pargs.bundle
        self.run(*args)

    @controller.expose(help='Clean static assets')
    def clean(self):
        self.run('clean')

    def run(self, *args):
        from webassets import script
        app = create_app()
        script.main(args, env=app.assets)


class App(cli.App):
    class Meta:
        label = 'decanter'
        base_controller = RootController
        handlers = (ServerController,
                    AssetController,
                    InstallDBController,
                    CreateRoleController,
                    CreateUserController)


if __name__ == '__main__':
    App.execute()
