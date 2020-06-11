# coding=utf-8
import unittest
from pyprobe.sensors.pegasus.controller import PegasusControllerParser, PegasusController

__author__ = 'Dirk Dittert'

SINGLE_CONTROLLER = """===============================================================================
Type  #    Model         Alias                            WWN
===============================================================================
hba   1  * Pegasus R6                                     2000-0001-5553-4378

"Totally 1 HBA(s) and 0 Subsystem(s)"""


class PegasusControllerParserTest(unittest.TestCase):

    def test_single_controller(self):
        parser = PegasusControllerParser(SINGLE_CONTROLLER)

        self.assertEqual(1, len(parser.controllers))

        ctrl = parser.controllers[0]
        self.assertEqual(PegasusController.PEGASUS_R6, ctrl.type)
        self.assertEqual(1, ctrl.controller_id)
        self.assertEqual("2000-0001-5553-4378", ctrl.wwn)