from ferris.core.controller import Controller, route_with, route
from ferrisnose import AppEngineWebTest


class TestController(Controller):

    class Meta:
        prefixes = ['pre']

    @route_with('/[controller]/[action]/<a>/<b>/<c>')
    @route_with('/[controller]/[action]/<a>/<b>')
    @route_with('/[controller]/[action]/<a>')
    @route_with('/[controller]/[action]')
    def method(self, a=0, b=0, c=0):
        return 'method_' + '/'.join([str(i) for i in (a, b, c)])

    @route_with('/[prefix]/[controller]/[action]/<a>/<b>/<c>')
    @route_with('/[prefix]/[controller]/[action]/<a>/<b>')
    @route_with('/[prefix]/[controller]/[action]/<a>')
    @route_with('/[prefix]/[controller]/[action]')
    def pre_method(self, a=0, b=0, c=0):
        return 'pre_method_' + '/'.join([str(i) for i in (a, b, c)])

    @route
    def urls(self):
        assert self.uri('test_controller:method') == '/test_controller/method'
        assert self.uri('test_controller:method-2', a=1) == '/test_controller/method/1'
        assert self.uri('test_controller:method-3', a=1, b=2) == '/test_controller/method/1/2'
        assert self.uri('test_controller:method-4', a=1, b=2, c=3) == '/test_controller/method/1/2/3'
        return 'done'

    @route
    def prefixed_urls(self):
        assert self.uri('pre:test_controller:method') == '/pre/test_controller/method'
        assert self.uri('pre:test_controller:method-2', a=1) == '/pre/test_controller/method/1'
        assert self.uri('pre:test_controller:method-3', a=1, b=2) == '/pre/test_controller/method/1/2'
        assert self.uri('pre:test_controller:method-4', a=1, b=2, c=3) == '/pre/test_controller/method/1/2/3'
        return 'done'


class DefaultArgsTest(AppEngineWebTest):

    def setUp(self):
        super(DefaultArgsTest, self).setUp()
        TestController._build_routes(self.testapp.app.router)

    def test_default_args(self):
        response = self.testapp.get('/test_controller/method')
        self.assertEqual(response.body, 'method_0/0/0')

        response = self.testapp.get('/test_controller/method/1')
        self.assertEqual(response.body, 'method_1/0/0')

        response = self.testapp.get('/test_controller/method/1/2')
        self.assertEqual(response.body, 'method_1/2/0')

        response = self.testapp.get('/test_controller/method/1/2/3')
        self.assertEqual(response.body, 'method_1/2/3')

    def test_prefixed_default_args(self):
        response = self.testapp.get('/pre/test_controller/method')
        self.assertEqual(response.body, 'pre_method_0/0/0')

        response = self.testapp.get('/pre/test_controller/method/1')
        self.assertEqual(response.body, 'pre_method_1/0/0')

        response = self.testapp.get('/pre/test_controller/method/1/2')
        self.assertEqual(response.body, 'pre_method_1/2/0')

        response = self.testapp.get('/pre/test_controller/method/1/2/3')
        self.assertEqual(response.body, 'pre_method_1/2/3')

    def test_stacking_route_uri_building(self):

        response = self.testapp.get('/test_controller/urls')
        self.assertEqual(response.body, 'done')

        response = self.testapp.get('/test_controller/prefixed_urls')
        self.assertEqual(response.body, 'done')
