import os
import tempfile
import unittest
import logging
from pyidf import ValidationLevel
import pyidf
from pyidf.idf import IDF
from pyidf.controllers import AirLoopHvacControllerList

log = logging.getLogger(__name__)

class TestAirLoopHvacControllerList(unittest.TestCase):

    def setUp(self):
        self.fd, self.path = tempfile.mkstemp()

    def tearDown(self):
        os.remove(self.path)

    def test_create_airloophvaccontrollerlist(self):

        pyidf.validation_level = ValidationLevel.error

        obj = AirLoopHvacControllerList()
        # alpha
        var_name = "Name"
        obj.name = var_name
        # alpha
        var_controller_1_object_type = "Controller:WaterCoil"
        obj.controller_1_object_type = var_controller_1_object_type
        # object-list
        var_controller_1_name = "object-list|Controller 1 Name"
        obj.controller_1_name = var_controller_1_name
        # alpha
        var_controller_2_object_type = "Controller:WaterCoil"
        obj.controller_2_object_type = var_controller_2_object_type
        # object-list
        var_controller_2_name = "object-list|Controller 2 Name"
        obj.controller_2_name = var_controller_2_name
        # alpha
        var_controller_3_object_type = "Controller:WaterCoil"
        obj.controller_3_object_type = var_controller_3_object_type
        # object-list
        var_controller_3_name = "object-list|Controller 3 Name"
        obj.controller_3_name = var_controller_3_name
        # alpha
        var_controller_4_object_type = "Controller:WaterCoil"
        obj.controller_4_object_type = var_controller_4_object_type
        # object-list
        var_controller_4_name = "object-list|Controller 4 Name"
        obj.controller_4_name = var_controller_4_name
        # alpha
        var_controller_5_object_type = "Controller:WaterCoil"
        obj.controller_5_object_type = var_controller_5_object_type
        # object-list
        var_controller_5_name = "object-list|Controller 5 Name"
        obj.controller_5_name = var_controller_5_name
        # alpha
        var_controller_6_object_type = "Controller:WaterCoil"
        obj.controller_6_object_type = var_controller_6_object_type
        # object-list
        var_controller_6_name = "object-list|Controller 6 Name"
        obj.controller_6_name = var_controller_6_name
        # alpha
        var_controller_7_object_type = "Controller:WaterCoil"
        obj.controller_7_object_type = var_controller_7_object_type
        # object-list
        var_controller_7_name = "object-list|Controller 7 Name"
        obj.controller_7_name = var_controller_7_name
        # alpha
        var_controller_8_object_type = "Controller:WaterCoil"
        obj.controller_8_object_type = var_controller_8_object_type
        # object-list
        var_controller_8_name = "object-list|Controller 8 Name"
        obj.controller_8_name = var_controller_8_name

        idf = IDF()
        idf.add(obj)
        idf.save(self.path, check=False)

        with open(self.path, mode='r') as f:
            for line in f:
                log.debug(line.strip())

        idf2 = IDF(self.path)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].name, var_name)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_1_object_type, var_controller_1_object_type)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_1_name, var_controller_1_name)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_2_object_type, var_controller_2_object_type)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_2_name, var_controller_2_name)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_3_object_type, var_controller_3_object_type)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_3_name, var_controller_3_name)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_4_object_type, var_controller_4_object_type)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_4_name, var_controller_4_name)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_5_object_type, var_controller_5_object_type)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_5_name, var_controller_5_name)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_6_object_type, var_controller_6_object_type)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_6_name, var_controller_6_name)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_7_object_type, var_controller_7_object_type)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_7_name, var_controller_7_name)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_8_object_type, var_controller_8_object_type)
        self.assertEqual(idf2.airloophvaccontrollerlists[0].controller_8_name, var_controller_8_name)