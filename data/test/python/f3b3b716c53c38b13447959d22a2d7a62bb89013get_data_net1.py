#!/usr/bin/python
import sys
from qpid.messaging import *

#global vars
broker_local = "localhost:5672"
addr_control = "agie_inbound/agie_inbound_data"


def broker_conn():
# create connection to local broker
        lb_connection = Connection(broker_local)
        try:
                lb_connection.open()
                session = lb_connection.session()
		receiver = session.receiver("agie_data_net1")
		while True:
			message = receiver.fetch()
			received = message.content
			print 'received', received
			session.acknowledge()
        except MessagingError,m:
                print m
        finally:
                lb_connection.close()

broker_conn()
