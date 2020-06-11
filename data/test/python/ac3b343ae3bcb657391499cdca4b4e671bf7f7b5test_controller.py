# pylint: disable=too-many-public-methods
import unittest

from rut.controller import Controller


class TestController(unittest.TestCase):

    def test_create(self):
        self.assertTrue(Controller())

    def test_send_command(self):
        controller = Controller()
        with self.assertRaises(SystemExit):
            controller.send_keys(":q\n")

    def test_clear_command(self):
        controller = Controller()
        with self.assertRaises(SystemExit):
            controller.send_keys(",,,\n:q\n")
