#!/usr/bin/env python

from Broker.Messages import Message, Publish, Authentication
from Broker.Transport import TCP, UDP, SSL
from Broker.Codecs import Protobuf as Codec #auto codec selection (thrift or protobuf if thrift isn't installed)
from Broker.Clients import Minimal

server='127.0.0.1'
destination = '/python/tests'
destination_type = 'QUEUE'
N=1000

broker = Minimal(codec=Codec(), transport=SSL(host=server))

broker.send(Authentication.from_sts_credentials(username='sapo@sapo.pt', password='passwd'))

for n in xrange(N):
    message = Message(payload='Message number %d' % n)
    publish = Publish(destination=destination, destination_type=destination_type, message=message)
    broker.send(publish)
