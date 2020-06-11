from flask import Flask
import os

import Controller
import ControllerType
import Actuator
import AutomationConfig

class MissingController(Exception):
    """No controller specified"""
    pass

class MissingId(Exception):
    """No controller specified"""
    pass

def Config():
    return AutomationConfig.Config()

def AddActuator(controller, config_dict):
    return controller.CreateActuator(config_dict)

def AddController(controller_type, config_dict):
    return controller_type.CreateController(config_dict)

def DeleteActuator(actuator_name):
    actuator = Actuator.Find(actuator_name)
    if actuator:
        Actuator.Delete(actuator)

def DeleteController(controller_name):
    Controller.Delete(controller_name)

def EditActuator(actuator, new_config_dict):
    actuator.Edit(new_config_dict)

def EditController(controller, new_config_dict):
    controller.Edit(new_config_dict)

def FindController(name):
    return Controller.Find(name)

def FindActuator(name):
    return Actuator.Find(name)

def NextOrder():
    return Actuator.NextOrder() 

def ToggleActuator(name):
    actuator = Actuator.Find(name)
    if actuator:
        actuator.SetState(not actuator.State())

def OrderedActuators(category=None):
    return Actuator.OrderedActuators(category)

def OrderedAliases(category=None):
    return Actuator.OrderedAliases(category)

def OrderedControllers(category=None):
    return Controller.OrderedControllers(category)

def FindControllerType(name):
    return ControllerType.Find(name)

def GetControllerTypes():
    return ControllerType.GetTypes()

def GetControllerNames():
    return Controller.GetNames()

def ActuatorCategories():
    return Actuator.ActuatorCategories()

def ControllerCategories():
    return Controller.ControllerCategories()

if __name__ == '__main__':
    AutomationConfig.Read()
    print "===== Controller Types ====="
    ControllerType.Dump()
    print "===== Controllers ====="
    Controller.DumpControllers()
    print "===== Actuators ====="
    Actuator.DumpActuators()
    if False:
        print "=== Config ==="
        config = AutomationConfig.Config()
        for section in config.sections():
            print '[', section, ']'
            for item in config.items(section):
                print '  ', item[0], '=', item[1]

