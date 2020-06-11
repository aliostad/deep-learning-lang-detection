import unittest

from controller import Controller

class ControllerTests(unittest.TestCase):
    '''
    This is the unittest for the uniscada.controller module
    '''
    def setUp(self):
        self.controller = Controller('123')

    def test_id(self):
        ''' Test controller id '''
        self.assertEqual(self.controller.get_id(), '123')

    def test_state_reg(self):
        ''' Test controller state register functions '''
        self.controller.set_state_reg('ABC', 123)
        self.assertEqual(self.controller.get_state_reg('ABC'), 123)
        self.assertEqual(self.controller.get_state_reg('xxx'), None)
