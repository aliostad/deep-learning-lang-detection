#!python
from __future__ import print_function
import time

from arduino_device import findArduinoDevicePorts
from arduino_olfactometer import ArduinoOlfactometers
from arduino_olfactometer import isOlfactometerPortInfo
from faa_actuation import PwmController
from faa_actuation import CurrentController
from faa_actuation import isPwmControllerPortInfo
from faa_actuation import isCurrentControllerPortInfo

DEBUG = True

class Actuation(object):
    def __init__(self,*args,**kwargs):
        t_start = time.time()
        pwm_controller_port = None
        olfactometer_ports = []
        current_controller_port = None
        self.pwm_controller = None
        self.olfactometers = None
        self.current_controller = None
        arduino_device_ports = findArduinoDevicePorts()
        for port in arduino_device_ports:
            port_info = arduino_device_ports[port]
            if isPwmControllerPortInfo(port_info):
                pwm_controller_port = port
            elif isOlfactometerPortInfo(port_info):
                olfactometer_ports.append(port)
            elif isCurrentControllerPortInfo(port_info):
                current_controller_port = port
        if pwm_controller_port is not None:
            self.pwm_controller = PwmController(port=pwm_controller_port)
            self.pwm_controller.setDeviceName('pwm_controller')
        if len(olfactometer_ports) != 0:
            self.olfactometers = ArduinoOlfactometers(use_ports=olfactometer_ports)
            self.olfactometers.sortBySerialNumber()
            try:
                self.olfactometers[0].setDeviceName('olfactometer_odor1')
                self.olfactometers[1].setDeviceName('olfactometer_odor2')
                self.olfactometers[2].setDeviceName('olfactometer_ethanol')
            except IndexError:
                pass
        if current_controller_port is not None:
            self.current_controller = CurrentController(port=current_controller_port)
            self.current_controller.setDeviceName('current_controller')

        t_end = time.time()
        print('Initialization time =', (t_end - t_start))
