#!/usr/bin/env python

# The Broker Name service.  A simple registration location for all control
# brokers.
# Copyright 2006 John T. Kamenik, LGPL, All rights reserved.

import os, sys, signal

try:
	from omniORB import CORBA
	import omniORB

	# for now assume we are being run from edcba root
	omniORB.importIDL("./idl/BrokerNameService.idl")

	import EDCBA__POA as EDCBA

	base = EDCBA.BrokerNameService
except:
	# if we can't be a CORBA object, then we can't be anything
	base = object


class Registration:
	'''Registration object used as a holding place for
	registration information'''

	def __init__(self, controlBroker, address):
		self.brokername = controlBroker
		self.ior        = address
		self.auth       = None

	def getBrokerName(self):
		'''Returns the Broker's Name'''
		return self.brokername

	def getAddress(self):
		'''Returns the Broker's Address'''
		return self.ior

	def getAuth(self):
		'''Returns a generated authtication string'''
		if not self.auth:
			from md5 import md5
			self.auth = md5()
			self.auth.update(self.brokername)
			self.auth.update(self.ior)
		return self.auth.hexdigest()


class NameService( base ):
	def __init__(self):
		print "Starting Broker Name Service"
		print "Waiting for registrations..."
		self.registered = {}

	def nsregister(self, controlBroker, address):
		print "Registering %s (%s)" % (controlBroker,address)
		if controlBroker in self.registered:
			print "ERROR: %s attempted to re-register without deregistering" %\
				(controlBroker)
			return None
		self.registered[controlBroker ] = Registration(controlBroker,address)
		return self.registered[controlBroker].getAuth()

	def deregister(self, auth, controlBroker):
		print "Deregistering %s" % (controlBroker)
		try:
			found = self.registered[controlBroker]
			if found.getAuth() == auth:
				del self.registered[controlBroker]
				return True
			else:
				print "Incorrect auth string for %s" % (controlBroker)
				return False
		except:
			print "ERROR: Failed to deregister %s" % (controlBroker)
			return False

	def getRegistered(self):
		return self.registered.keys()

	def getAddressOf(self, controlBroker):
		try:
			found = self.registered[controlBroker]
			return found.getAddress()
		except:
			return None


def quitHandler(signum, frame):
	raise KeyboardInterrupt


# if we are run as a program then act like a server
if __name__ == '__main__':
	orb = CORBA.ORB_init(sys.argv)

	server = NameService()
	objref = server._this()
	file('/tmp/BrokerNameService.ior', 'w').write(orb.object_to_string(objref))
	poa = orb.resolve_initial_references("RootPOA")
	poaManager = poa._get_the_POAManager()
	poaManager.activate()

	signal.signal(signal.SIGQUIT, quitHandler)
	signal.signal(signal.SIGTSTP, quitHandler)

	try:
		orb.run()
	except KeyboardInterrupt:
		pass
	os.unlink("/tmp/BrokerNameService.ior")
