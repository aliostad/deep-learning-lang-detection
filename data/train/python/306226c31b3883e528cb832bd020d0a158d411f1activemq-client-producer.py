#!/usr/bin/python
# -*- coding: utf-8 -*-

#################################################################
# File: activemq-client.py                                      #
# Description: Example using http://code.google.com/p/stomppy/  #
#                                                               #
# Author: Cristian Lucchesi <cristian.lucchesi@iit.cnr.it       #
# Last Modified: 2012-11-22 13:06                               #
#################################################################

import time
import sys

import stomp

BROKER_HOST = "www.devel.iit.cnr.it"
BROKER_PORT = 61613

conn = stomp.Connection([(BROKER_HOST, BROKER_PORT)])

conn.start()
conn.connect()

conn.send(' '.join(sys.argv[1:]), destination='/queue/test')
#time.sleep(1000)
conn.disconnect()
