#!/usr/bin/env python

from Broker.Messages import Message, Publish
from Broker.Transport import TCP, UDP, SSL
from Broker.Codecs import Codec #auto codec selection (thrift or protobuf if thrift isn't installed)
from Broker.Clients import Minimal

from datetime import datetime, timedelta

delta = timedelta(seconds=30)

server='broker.bk.sapo.pt'
destination = '/python/tests/expiration'
destination_type = 'QUEUE'
N=10000

broker = Minimal(codec=Codec(), transport=TCP(host=server))

for n in xrange(N):
    payload = payload='Message number %d' % n
    message = Message(payload=payload, expiration=datetime.utcnow()+delta)
    raw_input('produce %r' % (payload,))
    publish = Publish(destination=destination, destination_type=destination_type, message=message)
    broker.send(publish)
