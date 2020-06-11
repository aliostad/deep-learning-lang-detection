from unittest2 import TestCase

from mesh.bundle import *
from mesh.resource import *

class TestCase(TestCase):
    def setUp(self):
        self.configuration = Configuration()

        class Example(Resource):
            configuration = self.configuration
            name = 'example'
            version = 1

        self.resource_1 = Example

        class Example(Example):
            name = 'example'
            version = 2

        self.resource_2 = Example

        class ExampleController(Controller):
            resource = Example
            version = (1, 0)

        self.controller_1_0 = ExampleController

        class ExampleController(ExampleController):
            resource = Example
            version = (1, 1)

        self.controller_1_1 = ExampleController

        class ExampleController(ExampleController):
            resource = Example
            version = (2, 0)

        self.controller_2_0 = ExampleController

        class ExampleController(ExampleController):
            resource = Example
            version = (2, 1)

        self.controller_2_1 = ExampleController

        self.Example = Example
        self.ExampleController = ExampleController

class TestMount(TestCase):
    def test_null_mount(self):
        m = mount(None)
        m.construct(None)
        for attr in ('resource', 'controller', 'min_version', 'max_version'):
            self.assertIs(getattr(m, attr, None), None)

    #def test_mount_without_controller(self):
    #    m = mount(self.Example)
    #    m.construct(None)
    #    assert m.resource is self.Example
    #    assert m.controller is None
    #    assert m.min_version == (1, 0)
    #    assert m.max_version == (2, 0)
    #    assert m.versions == [(1, 0), (2, 0)]

    def test_mount_with_controller(self):
        m = mount(self.Example, self.ExampleController)
        m.construct(None)
        self.assertIs(m.resource, self.Example)
        self.assertIs(m.controller, self.ExampleController)
        self.assertEqual(m.min_version, (1, 0))
        self.assertEqual(m.max_version, (2, 1))
        self.assertEqual(m.versions, [(1, 0), (1, 1), (2, 0), (2, 1)])

    def test_mount_with_min_version(self):
        m = mount(self.Example, self.ExampleController, min_version=(1, 1))
        m.construct(None)
        self.assertEqual(m.min_version, (1, 1))
        self.assertEqual(m.max_version, (2, 1))
        self.assertEqual(m.versions, [(1, 1), (2, 0), (2, 1)])

    def test_mount_with_max_version(self):
        m = mount(self.Example, self.ExampleController, max_version=(2, 0))
        m.construct(None)
        self.assertEqual(m.min_version, (1, 0))
        self.assertEqual(m.max_version, (2, 0))
        self.assertEqual(m.versions, [(1, 0), (1, 1), (2, 0)])

    def test_mount_with_both_versions(self):
        m = mount(self.Example, self.ExampleController, min_version=(1, 1), max_version=(2, 0))
        m.construct(None)
        self.assertEqual(m.min_version, (1, 1))
        self.assertEqual(m.max_version, (2, 0))
        self.assertEqual(m.versions, [(1, 1), (2, 0)])

class TestBundle(TestCase):
    def test_simple_bundle(self):
        bundle = Bundle('bundle',
            mount(self.Example, self.ExampleController)
        )
        
        self.assertEqual(bundle.ordering, [(1, 0), (1, 1), (2, 0), (2, 1)])
