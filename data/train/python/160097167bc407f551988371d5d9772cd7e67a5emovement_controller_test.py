""" This is a unit test for the MovementController class. The suite tests all methods to ensure functionality """

import math
import unittest

from src.movement_controller import MovementController

class MovementControllerTester(unittest.TestCase):
    def setUp(self):
        self.movement_controller = MovementController()

if __name__ == '__main__': # load and run test suites
    suite = unittest.TestLoader().loadTestsFromTestCase(MovementControllerTester)
    unittest.TextTestRunner(verbosity=3).run(suite)
