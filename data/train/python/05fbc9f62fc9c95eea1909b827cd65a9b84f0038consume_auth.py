#!/usr/bin/env python

from Broker.Messages import Message, Authentication, Poll, Acknowledge
from Broker.Transport import TCP, UDP, SSL
from Broker.Codecs import Codec
from Broker.Clients import Minimal

server='broker.bk.sapo.pt'
destination = '/perl/tests'
destination_type = 'QUEUE'
N=1000

broker = Minimal(codec=Codec(), transport=SSL(host=server))

broker.send(Authentication.from_sts_credentials(username='sapo@sapo.pt', password='passwd'))

for n in xrange(N):
    broker.send(Poll(destination=destination, timeout=0))
    message = broker.receive()
    print message
    broker.send(Acknowledge(message_id=message.message.id, destination=message.subscription))
    
