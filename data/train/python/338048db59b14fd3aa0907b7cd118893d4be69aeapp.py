from cement.core import controller, foundation

class BaseController(controller.CementBaseController):
    class Meta(object):
        label = 'base'
        
    @controller.expose(hide=True, aliases=['help'])
    def default(self):
        self.app.args.print_help()


class ChewcorpApp(foundation.CementApp):
    class Meta(object):
        label = 'chewcorp'
        base_controller = BaseController
        extensions = [
            'chewcorp.cli.ext.ext_dns',
            'chewcorp.cli.ext.ext_instances',
            'chewcorp.cli.ext.ext_oauth',
        ]
        
def run():
    with ChewcorpApp() as app:
        app.run()

if __name__ == '__main__':
    run()
