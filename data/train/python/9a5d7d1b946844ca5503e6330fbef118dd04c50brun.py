#!/usr/bin/python

#import RPi.GPIO as GPIO
from tasks.button import TaskButton
from tasks.led import TaskLEDIndicator
from tasks.systemstatus import TaskSystemStatus
from controller import PiController

import tempfile
import os

#GPIO.setmode(GPIO.BCM)
controller = PiController()

sfile = os.path.normpath(tempfile.gettempdir() + os.sep + "pi-system-loaded.tmp")

controller.addTask("button", TaskButton(controller, 24))
controller.addTask("led", TaskLEDIndicator(controller, 22))
controller.addTask("systatus", TaskSystemStatus(controller, sfile))

controller.start()

#GPIO.cleanup()
