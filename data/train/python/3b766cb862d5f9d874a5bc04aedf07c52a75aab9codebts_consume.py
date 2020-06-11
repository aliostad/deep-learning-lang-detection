#!/usr/bin/env python

from Broker.Messages import Message, Subscribe, Acknowledge
from Broker.Transport import TCP, UDP
from Broker.Codecs import Codec #auto codec selection (thrift or protobuf if thrift isn't installed)
from Broker.Clients import Minimal

server='broker.labs.sapo.pt'
destination = '.*'
destination_type = 'TOPIC'
N=10000

broker = Minimal(codec=Codec(), transport=TCP(host=server))

broker.send(Subscribe(destination=destination, destination_type=destination_type))
for n in xrange(N):
    message = broker.receive()
    broker.send(Acknowledge(message_id=message.message.id, destination=message.destination))
    print message.message.payload
