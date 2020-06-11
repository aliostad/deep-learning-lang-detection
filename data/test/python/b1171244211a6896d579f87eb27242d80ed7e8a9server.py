import logging
import sys
import time
import eventlet
from drivel.messaging.broker import Broker
broker = Broker('brokertest', 'server')
broker.connections.listen(('', 8899))

BLOCK = 10000

q = eventlet.Queue()
def handler():
    start = None
    count = 0
    x = 0
    while True:
        event, msg = q.get()
        if start is None:
            start = time.time()
        else:
            count += 1
            if count == BLOCK:
                t = time.time() - start
                x += 1
                print '%d\t%s\t%s' % (x, (count/t), t)
                count = 0
                start = time.time()
        event.send('bye')

if '-d' in sys.argv:
    logging.basicConfig(level=logging.DEBUG)

broker.subscribe('hello', q)
g = eventlet.spawn(handler)
eventlet.spawn(broker.listen)
broker.process()
