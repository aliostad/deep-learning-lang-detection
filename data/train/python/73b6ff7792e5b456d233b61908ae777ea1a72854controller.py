#!/usr/bin/python

from client.telescope_client import TelescopeControllerClient

telescope_controller_client = TelescopeControllerClient()

def getinfo():
	global telescope_controller_client
	return telescope_controller_client.getinfo()

def setdec(DEC):
	global telescope_controller_client
	return telescope_controller_client.setdec(DEC)

def setra(RA):
	global telescope_controller_client
	return telescope_controller_client.setra(RA)

def setslewrate(slew):
	global telescope_controller_client
	return telescope_controller_client.setslewrate(slew)

def seteqtarget(RA,DEC):
	global telescope_controller_client
	return telescope_controller_client.seteqtarget(RA,DEC)

def setaltaztarget(ALT,AZ):
	global telescope_controller_client
	return telescope_controller_client.setaltaztarget(ALT,AZ)

def park():
	global telescope_controller_client
	return telescope_controller_client.park()

def stopSlewing():
	global telescope_controller_client
	return telescope_controller_client.stopSlewing()
