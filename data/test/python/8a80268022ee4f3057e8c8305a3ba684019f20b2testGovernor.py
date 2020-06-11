#!rusr/bin/python

from pitmGovernor import *


controller = pitmController()
controller.fermLow=18
controller.fermHigh=20
controller.fermTarget=19
controller.hltLow=81
controller.hltTarget=82
controller.hltHigh=83
controller.spargeLow=87
controller.spargetTarget=88
controller.spargeHigh=89
controller.mashLow=67
controller.mashTarget=68
controller.mashHigh=69
controller.boilLow=99
controller.boilHigh=101
controller.boilTarget=100
controller._recipe="Test Recipe"
controller._brewlog="Test Brewlog"
controller.startOrders()
controller.mainButtonLoop()
