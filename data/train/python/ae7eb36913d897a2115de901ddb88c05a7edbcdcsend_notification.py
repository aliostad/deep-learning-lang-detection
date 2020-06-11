#!/usr/bin/python

from qpid.messaging import *
from qmf.console import Session as QmfSession
import socket

broker = "127.0.0.1:5672"
address = "mrg.grid.config.notifications"

connection = Connection(broker)

try:
  qmfsession = QmfSession()
  broker = qmfsession.addBroker(broker,30, "ANONYMOUS")

  # Declare the exchange
  broker.getAmqpSession().exchange_declare(exchange=address, type="fanout")
  qmfsession.delBroker(broker)
  del qmfsession

  connection.open()
  session = connection.session()

#  content = {"nodes": [socket.gethostname()], "version": "a1b2c3d4e5f6g7h8"}
  content = {"nodes": [socket.gethostname()]}
  sender = session.sender(address)
  sender.send(Message(content=content))
except MessagingError,m:
  print m
except Exception, e:
  print e
finally:
  connection.close()
