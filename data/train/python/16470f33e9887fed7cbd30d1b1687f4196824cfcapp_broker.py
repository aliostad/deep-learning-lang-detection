import logging
import traceback
from multiprocessing import Process

import zmq

from utils import uninterruptible
from config import c

log = logging.getLogger(__name__)


class AppBroker(Process):

    def run(self):
        """Initializes the application broker"""
        try:
            context = zmq.Context(1)

            # setup application broker
            subscriber = context.socket(zmq.SUB)
            subscriber.bind(c.broker.sub_bind)
            subscriber.setsockopt(zmq.SUBSCRIBE, "")

            publisher = context.socket(zmq.PUB)
            publisher.bind(c.broker.pub_bind)

            print "starting zmq application broker"
            uninterruptible(zmq.device, zmq.FORWARDER, subscriber, publisher)
        except KeyboardInterrupt:
            print "Killing, keyboard interrupt"
        except Exception:
            traceback.print_exc()
            print "bringing down applicaiotn zmq broker"
        finally:
            subscriber.close()
            publisher.close()
            context.term()


if __name__ == '__main__':
    app = AppBroker()
    app.run()
