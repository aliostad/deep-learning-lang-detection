# Copyright (c) 2014 Adam Drakeford <adam.drakeford@gmail.com>
# See LICENSE for more details

"""
Tests for txREST controllers
"""

from twisted.web import resource
from twisted.trial import unittest

from txrest import controller
from txrest.managers.controllers import ControlManager

from txrest.tests.helpers import (
    MockBaseController, MockController, MockControllerChildOne,
    MockControllerChildTwo, MockControllerSubChildOne,
    MockControllerSubChildTwo
)


class ControllerTest(unittest.TestCase):
    """ Tests for txrest.controller
    """

    def setUp(self):
        self.c = controller.BaseController()

    def test_class_inherits_twisted_web_resource(self):
        self.assertTrue(
            issubclass(controller.BaseController, resource.Resource)
        )

    def test_parent_is_none_by_default(self):
        self.assertIsNone(self.c.__parent__)

    def test_register_path_returns_empty(self):
        self.assertEqual(self.c.get_path(), '')


class ControllerManagerTest(unittest.TestCase):
    """ Tests for txrest.managers.controllers
    """

    def setUp(self):
        self.mgr = ControlManager()

    def tearDown(self):
        self.mgr._controllers.clear()

    def test_install_controller(self):
        controller = MockController()
        self.mgr.install_controller(controller)
        self.assertEqual(len(self.mgr._controllers), 1)

        c = self.mgr._controllers.get(controller.get_path())
        self.assertEqual(c, controller)

    def test_get_controllers_is_list(self):
        self.assertIsInstance(self.mgr.get_controllers(), list)

    def test_get_controllers_is_empty(self):
        self.assertEqual(len(self.mgr.get_controllers()), 0)

    def test_length(self):
        self.assertEqual(len(self.mgr), 0)

    def test_length_after_install(self):
        controller = MockController()
        self.mgr.install_controller(controller)
        self.assertEqual(len(self.mgr), 1)

    def test_get_root_controller(self):
        controller = MockController()
        self.mgr.install_controller(controller)
        base_controller = self.mgr.get_root_controller()
        self.assertIsInstance(base_controller, MockBaseController)

    def test_get_full_path(self):
        controller = MockController()
        self.mgr.install_controller(controller)
        path = self.mgr.get_full_route(controller)
        self.assertEqual(path, '/api')

    def test_get_full_path_on_child(self):
        parent = MockController()
        self.mgr.install_controller(parent)

        child = MockControllerChildOne()
        self.mgr.install_controller(child)

        path = self.mgr.get_full_route(parent)
        self.assertEqual(path, '/api')

        path = self.mgr.get_full_route(child)
        self.assertEqual(path, '/api/v1')

    def test_get_full_path_on_multiple_children(self):
        parent = MockController()
        self.mgr.install_controller(parent)

        child1 = MockControllerChildOne()
        self.mgr.install_controller(child1)

        child2 = MockControllerChildTwo()
        self.mgr.install_controller(child2)

        path = self.mgr.get_full_route(parent)
        self.assertEqual(path, '/api')

        path = self.mgr.get_full_route(child1)
        self.assertEqual(path, '/api/v1')

        path = self.mgr.get_full_route(child2)
        self.assertEqual(path, '/api/v2')

    def test_get_full_path_on_multiple_children_and_subchildren(self):
        parent = MockController()
        self.mgr.install_controller(parent)

        child1 = MockControllerChildOne()
        self.mgr.install_controller(child1)

        child2 = MockControllerChildTwo()
        self.mgr.install_controller(child2)

        sub1 = MockControllerSubChildOne()
        self.mgr.install_controller(sub1)

        sub2 = MockControllerSubChildTwo()
        self.mgr.install_controller(sub2)

        path = self.mgr.get_full_route(parent)
        self.assertEqual(path, '/api')

        path = self.mgr.get_full_route(child1)
        self.assertEqual(path, '/api/v1')

        path = self.mgr.get_full_route(child2)
        self.assertEqual(path, '/api/v2')

        path = self.mgr.get_full_route(sub1)
        self.assertEqual(path, '/api/v1/test1')

        path = self.mgr.get_full_route(sub2)
        self.assertEqual(path, '/api/v2/test2')
