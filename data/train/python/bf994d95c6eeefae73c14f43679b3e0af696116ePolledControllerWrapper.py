#!/usr/bin/python

from IRobot import IRobot
from IRobotController import IRobotController
from Point import Point

class PolledControllerWrapper(IRobotController,object):
    def __init__(self,ctlr):
        self.controller = ctlr
        self.robot = IRobot()

    def start(self):
        # Invoke the controlRobot method until the finish location is reached
        while (self.robot.getLocation() != self.robot.getTargetLocation()):
            self.controller.controlRobot(self.robot)
            self.robot.jsondump()

    def setRobot(self, robot):
        self.robot = robot
    
    def reset(self):
        # If the controller has a reset function, call it before resetting normally
        if hasattr(self.controller,'reset'):
            self.controller.reset()
        self.robot.reset()

    def getDescription(self):
        return "Polled Controller"