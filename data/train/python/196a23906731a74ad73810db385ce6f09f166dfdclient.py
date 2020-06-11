import logging
import sys

import eventlet
from eventlet import debug
from drivel.messaging.broker import Broker
#eventlet.debug.hub_blocking_detection(True)
broker = Broker('brokertest', 'client')
broker.connections.connect(('127.0.0.1', 8899))
eventlet.spawn(broker.listen)
eventlet.spawn(broker.process)

p = eventlet.GreenPool()

if '-d' in sys.argv:
    logging.basicConfig(level=logging.DEBUG)

def do(broker):
    event = broker.send(broker.BROADCAST, 'hello', 'hello')
    #eventlet.sleep(0)
    event.wait()

while True:
    g = p.spawn(do, broker)
    if '-1' in sys.argv:
        g.wait()
        print 'done...'
        eventlet.sleep(1)
        break
