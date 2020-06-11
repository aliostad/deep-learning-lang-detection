import inspect
import pkg_resources

from datetime import timedelta
from moksha.pastetemplate import MokshaControllerTemplate

from moksha.lib.base import Controller

from base import QuickstartTester, setup_quickstart, teardown_quickstart

app = None

def setup():
    template_vars = {
            'package': 'mokshatest',
            'project': 'mokshatest',
            'egg': 'mokshatest',
            'egg_plugins': ['Moksha'],
    }
    args = {
        'controller': True,
        'controller_name': 'MokshatestController',
    }
    template = MokshaControllerTemplate
    templates = ['moksha.controller']
    global app
    app = setup_quickstart(template=template, templates=templates, args=args,
                           template_vars=template_vars)


def teardown():
    teardown_quickstart()


class TestControllerQuickstart(QuickstartTester):

    def setUp(self):
        self.app = app

    def get_controller(self):
        return self.get_entry('moksha.application')

    def test_entry_point(self):
        assert self.get_controller(), \
                "Cannot find mokshatest on `moksha.app` entry-point"

    def test_controller_class(self):
        assert isinstance(self.get_controller(), Controller) or \
               issubclass(self.get_controller(), Controller)

    def test_controller_call_index(self):
        controller = self.get_controller()()
        result = controller.index()
        assert result == {'name': 'world'}

    def test_controller_index(self):
        resp = self.app.get('/apps/mokshatest')
        assert 'Hello' in resp, resp

    def test_controller_index(self):
        resp = self.app.get('/apps/mokshatest?name=world')
        assert 'Hello world' in resp, resp
