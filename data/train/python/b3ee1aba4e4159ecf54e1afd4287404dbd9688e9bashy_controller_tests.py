#!/usr/bin/env python

import  unittest
from src.bashy_controller import BashyController

class TestBashyController(unittest.TestCase):

    def setUp(self):
        self.controller = BashyController()

    def test_constructor(self):
        self.assertTrue(self.controller.filesystem)
        self.assertTrue(self.controller.history)


##########################
def suite():
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(TestBashyController))
    return suite

if __name__ == '__main__':
    unittest.main()
