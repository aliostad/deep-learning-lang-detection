import sys
import unittest

try:
    from StringIO import StringIO
except:
    from io import StringIO

class TestControllerPlugin(unittest.TestCase):

    # Factory

    def test_make_cache_controllerplugin_factory(self):
        from supervisor_cache import controllerplugin
        controller = DummyController()

        plugin = controllerplugin.make_cache_controllerplugin(controller)
        self.assertEqual(controller, plugin.ctl)

    # Constructor

    def test_ctor_assigns_controller(self):
        controller = DummyController()

        plugin = self.makeOne(controller)
        self.assertEqual(controller, plugin.ctl)

    # cache_clear

    def test_do_cache_clear(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        cache_interface = plugin.cache
        cache_interface.cache = dict(foo='bar')

        plugin.do_cache_clear('')
        self.assertEqual({}, cache_interface.cache)

    def test_do_cache_clear_accepts_no_args(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.do_cache_clear('arg')
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_clear'))

    def test_help_cache_clear(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.help_cache_clear()
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_clear'))

    # cache_count

    def test_do_cache_count(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        cache_interface = plugin.cache
        cache_interface.cache = dict(foo='bar', baz='qux')

        plugin.do_cache_count('')
        output = controller.sio.getvalue()
        self.assertEqual('2', output)

    def test_do_cache_count_accepts_no_args(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.do_cache_count('arg')
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_count'))

    def test_help_cache_count(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.help_cache_count()
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_count'))

    # cache_delete

    def test_do_cache_delete(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        cache_interface = plugin.cache
        cache_interface.cache = dict(foo='bar', baz='qux')

        plugin.do_cache_delete('foo')
        self.assertTrue('foo' not in cache_interface.cache.keys())
        self.assertEqual('qux', cache_interface.cache['baz'])

    def test_do_cache_delete_accepts_a_quoted_arg(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        cache_interface = plugin.cache
        cache_interface.cache = {'f o o': 'bar', 'baz': 'qux'}

        plugin.do_cache_delete('"f o o"')
        self.assertTrue('f o o' not in cache_interface.cache.keys())

    def test_do_cache_delete_accepts_only_one_arg(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.do_cache_delete('first second')
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_delete'))

    def test_help_cache_delete(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.help_cache_delete()
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_delete <key>'))

    # cache_fetch

    def test_do_cache_fetch(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        cache_interface = plugin.cache
        cache_interface.cache = dict(foo='bar')

        plugin.do_cache_fetch('foo')
        out = controller.sio.getvalue()
        self.assertEqual("'bar'", out)

    def test_do_cache_fetch_accepts_a_quoted_arg(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        cache_interface = plugin.cache
        cache_interface.cache = {'f o o': 'bar'}

        plugin.do_cache_fetch('"f o o"')
        out = controller.sio.getvalue()
        self.assertEqual("'bar'", out)

    def test_do_cache_fetch_accepts_only_one_arg(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.do_cache_fetch('first second')
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_fetch'))

    def test_help_cache_fetch(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.help_cache_fetch()
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_fetch <key>'))

    # cache_keys

    def test_do_cache_keys(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        cache_interface = plugin.cache
        cache_interface.cache = dict(foo='bar', baz='qux')
        plugin.do_cache_keys('')

        output = controller.sio.getvalue()
        self.assertTrue('foo' in output)
        self.assertTrue('baz' in output)

    def test_do_cache_keys_accepts_no_args(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.do_cache_keys('arg')
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_keys'))

    def test_help_cache_keys(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.help_cache_keys()
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_keys'))

    # cache_store

    def test_do_cache_store(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        cache_interface = plugin.cache
        cache_interface.cache = {}
        plugin.do_cache_store('foo bar')
        self.assertEqual('bar', cache_interface.cache['foo'])

    def test_do_cache_store_accepts_a_quoted_key(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        cache_interface = plugin.cache
        cache_interface.cache = {}
        plugin.do_cache_store('"foo bar" baz')
        self.assertEqual('baz', cache_interface.cache['foo bar'])

    def test_do_cache_store_accepts_a_quoted_value(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        cache_interface = plugin.cache
        cache_interface.cache = {}
        plugin.do_cache_store('foo "bar baz"')
        self.assertEqual('bar baz', cache_interface.cache['foo'])

    def test_do_cache_store_accepts_no_less_than_two_args(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.do_cache_store('first')
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_store'))

    def test_do_cache_store_accepts_no_more_than_two_args(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.do_cache_store('first second third')
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_store'))

    def test_help_cache_store(self):
        controller = DummyController()
        plugin = self.makeOne(controller)

        plugin.help_cache_store()
        out = controller.sio.getvalue()
        self.assertTrue(out.startswith('cache_store <key> <value>'))

    # Test Helpers

    def makeOne(self, *arg, **kw):
        return self.getTargetClass()(*arg, **kw)

    def getTargetClass(self):
        from supervisor_cache.controllerplugin import CacheControllerPlugin
        return CacheControllerPlugin


class DummyController:
    def __init__(self):
        self.sio = StringIO()

    def output(self, out):
        assert(isinstance(out, str))
        self.sio.write(out)

    def get_server_proxy(self, namespace=None):
        if namespace == 'cache':
            from supervisor.tests.base import DummySupervisor
            supervisor = DummySupervisor()

            from supervisor_cache.rpcinterface import CacheNamespaceRPCInterface
            cache = CacheNamespaceRPCInterface(supervisor)

            return cache


def test_suite():
    return unittest.findTestCases(sys.modules[__name__])

if __name__ == '__main__':
    unittest.main(defaultTest='test_suite')
