#!/usr/bin/env python

# A simple test cli.
# Copyright 2006 John T. Kamenik, LGPL, All rights reserved.

import sys,signal

def quitHandler(signum, frame):
	raise KeyboardInterrupt

signal.signal(signal.SIGQUIT, quitHandler)
signal.signal(signal.SIGTSTP, quitHandler)

from omniORB import CORBA
import omniORB

omniORB.omniidlArguments(["-I./idl"])
omniORB.importIDL("./idl/BrokerNameService.idl")
omniORB.importIDL("./idl/IPControlBroker.idl")

import EDCBA__POA as EDCBA

orb          = CORBA.ORB_init(sys.argv)
ior          = file('/tmp/BrokerNameService.ior').read()
obj          = orb.string_to_object(ior)
nameservice  = obj._narrow(EDCBA.BrokerNameService)

registered = nameservice.getRegistered()

for item in registered:
	print "%s: %s" %( item, nameservice.getAddressOf(item))

if 'IP Broker' in registered:
	import EDCBA
	print "IP broker exists"
	tmp      = orb.string_to_object(nameservice.getAddressOf('IP Broker'))
	ipBroker = tmp._narrow(EDCBA.IPControlBroker)
	print 'Adding test: %s' % ipBroker.addInterface('test')
	print 'Adding test again: %s' % ipBroker.addInterface('test')
	print 'Adding test1: %s' % ipBroker.addInterface('test1')
	print 'Adding test2: %s' % ipBroker.addInterface('test2')
	ipBroker.test(EDCBA.IPInterface(None,None,None,None,None))
	print ipBroker.getInterface('test')
	items = ipBroker.getInterfaces()
	print items
