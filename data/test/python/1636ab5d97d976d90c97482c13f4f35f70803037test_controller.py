import unittest
import sys, os
from pprint import pprint

#Adding our src folder to import path so code from within src folder can be imported easily
sys.path.insert(0, os.path.dirname(os.path.abspath('.')) + '/src')

from controller import controller as c


class TestController(unittest.TestCase):
    def setUp(self):
        os.system('touch /tmp/controller_in')
        os.system('touch /tmp/controller_out')
        self.my_controller = c.Controller('/tmp/controller_in', '/tmp/controller_out')
        
    def test_controller1(self):
        "Controller - Test 1 - Set friendly name of section"
        self.my_controller.set_section_friendly_name(2 , "Living Room")
        assert 'Living Room' == self.my_controller.get_section_friendly_name(2)
        assert 2 == self.my_controller.get_section_number('Living Room')

    def test_controller2(self):
        "Controller - Test 2 - Set friendly name of device"
        self.my_controller.set_device_friendly_name(2, 1, 'Tube Light')
        assert 'Tube Light' == self.my_controller.get_device_friendly_name(2, 1)
        assert 1 == self.my_controller.get_device_number(2, 'Tube Light')
    
    #using section name instead of number
    def test_controller3(self):
        "Controller - Test 3 - Set friendly name of device"
        
        self.my_controller.set_section_friendly_name(2 , "Living Room")
        self.my_controller.set_device_friendly_name("Living Room", 3, 'Fan')
        
        assert 'Fan' == self.my_controller.get_device_friendly_name("Living Room", 3)
        assert 3 == self.my_controller.get_device_number("Living Room", 'Fan')
     
    def test_controller4(self):
        "Controller - Test 4 -Set status of device"
        self.my_controller.set_section_friendly_name(2 , "Living Room")
        self.my_controller.set_device_friendly_name(2, 1, 'Tube Light')
        self.my_controller.set_device_status("Living Room" , 'Tube Light' , 'ON')
        assert 'ON' == self.my_controller.get_device_status("Living Room", "Tube Light")
    
