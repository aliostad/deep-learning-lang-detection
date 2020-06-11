#!/usr/bin/python
import sys
from qpid.messaging import *

#global vars
broker_local = "localhost:5672"
addr_control = "agie_data_net1; {create:always, node:{x-declare:{auto-delete:true, alternate-exchange: 'amq.direct'}}}"
pri = 1

# create connection to local broker
lb_connection = Connection(broker_local)
try:
	lb_connection.open()
	session = lb_connection.session()
	sender = session.sender(addr_control)
	msg_content = "hello world"
	msg = Message(msg_content)
	print 'sending msg with content:', msg_content
	sender.send(msg)
except MessagingError,m:
	print m
finally:
	lb_connection.close()

