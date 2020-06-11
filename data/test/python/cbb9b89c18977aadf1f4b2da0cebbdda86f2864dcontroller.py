#!/usr/bin/python

#import client.dome_controller_client as dome_controller_client
from client.dome_controller_client import DomeControllerClient

dome_controller_client = DomeControllerClient()

def open_dome(speed):
	global dome_controller_client
	return dome_controller_client.try_open(speed)

def close_dome(speed):
	global dome_controller_client
	return dome_controller_client.try_close(speed)

def emergency_stop():
	global dome_controller_client
	return dome_controller_client.emergency_stop()

def refresh_dome_status():
	global dome_controller_client
	return dome_controller_client.try_refresh_dome_status()

def getSiderealTime(eLong):
	global dome_controller_client
	return dome_controller_client.getSiderealTime(eLong)
