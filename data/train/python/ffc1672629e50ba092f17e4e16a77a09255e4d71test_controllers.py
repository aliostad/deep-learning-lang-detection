import unittest

from controllers import Controllers
from controller import Controller

class ControllersTests(unittest.TestCase):
    '''
    This is the unittest for the uniscada.controllers module
    '''
    def setUp(self):
        self.controllers = Controllers()

    def test_add_controller(self):
        ''' Test controller add and lookup '''
        id1 = self.controllers.find_controller('A')
        id2 = self.controllers.find_controller('A')
        id3 = self.controllers.find_controller('B')
        self.assertTrue(isinstance(id1, Controller))
        self.assertTrue(isinstance(id2, Controller))
        self.assertTrue(isinstance(id3, Controller))
        self.assertEqual(id1, id2)
        self.assertNotEqual(id1, id3)

    def test_controller_id_listing(self):
        ''' Test controller id listing '''
        id1 = self.controllers.find_controller('A')
        id2 = self.controllers.find_controller('B')
        id3 = self.controllers.find_controller('C')
        self.assertEqual(sorted(self.controllers.get_id_list()), ['A', 'B', 'C'])
