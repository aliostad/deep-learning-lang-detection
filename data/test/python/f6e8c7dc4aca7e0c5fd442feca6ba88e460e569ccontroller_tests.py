import unittest
from model import Province

__author__ = 'peter'


class ControllerTests(unittest.TestCase):
    def test_can_assign_controller_to_unowned_province(self):
        self.assertEqual(Province(1).populate_model([{'controller':'SWE'}],True).controller['value'], 'SWE')

    def test_can_assign_controller_to_owned_province(self):
        province = Province(1)
        province.controller = {'value': 'NOR', 'modified': False }
        self.assertEqual(province.populate_model([{'controller':'SWE'}],True).controller['value'], 'SWE')

    def test_can_assign_no_controller_to_province(self):
        province = Province(1)
        province.controller = {'value': 'NOR', 'modified': False }
        self.assertEqual(province.populate_model([{'controller':None}],True).controller['value'], None)