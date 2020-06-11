#!/usr/bin/env python

from Broker.Messages import Message, Poll, Acknowledge
from Broker.Transport import TCP, UDP
from Broker.Codecs import Codec #auto codec selection (thrift or protobuf if thrift isn't installed)
from Broker.Clients import Minimal

server='broker.bk.sapo.pt'
destination = '/python/tests/expiration'
N=10000

broker = Minimal(codec=Codec(), transport=TCP(host=server))

for n in xrange(N):
    broker.send(Poll(destination=destination, timeout=0))
    message = broker.receive()
    broker.send(Acknowledge(message_id=message.message.id, destination=message.subscription))
    print message.message.payload
