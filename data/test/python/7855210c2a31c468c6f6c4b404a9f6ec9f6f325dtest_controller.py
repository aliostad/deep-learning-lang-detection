#!/usr/bin/env python

import unittest
import testing_helper

from softsailor.controller import *
from softsailor.boat import SailBoat

class TestController(unittest.TestCase):
    def setUp(self):
        self.controller = Controller()

    def TestSteerHeading(self):
        self.controller.steer_heading(3.14)

    def TestSteerWindAngle(self):
        self.controller.steer_wind_angle(1.57)

    def TestStop(self):
        self.controller.stop()

    def TestSetMainSail(self):
        self.controller.set_main_sail(2)

    def TestSetHeadSail(self):
        self.controller.set_head_sail(3)

    def TestSetSpinnaker(self):
        self.controller.set_spinnaker(1)

class TestBoatController(TestController):
    def setUp(self):
        self.boat = SailBoat()
        self.controller = BoatController(self.boat)

if __name__ == '__main__':
    unittest.main()
