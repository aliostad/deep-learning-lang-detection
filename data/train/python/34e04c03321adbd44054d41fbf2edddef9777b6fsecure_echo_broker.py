import sys
import logging.config

import zmq
from zmq.auth.thread import ThreadAuthenticator

from seas.zutil.auth import Key
from seas.zutil.mdp import SecureMajorDomoBroker

logging.config.fileConfig('logging.ini')


def main():
    auth = ThreadAuthenticator(zmq.Context.instance())
    auth.start()
    auth.allow('127.0.0.1')
    # Tell the authenticator how to handle CURVE requests
    auth.configure_curve(domain='*', location=zmq.auth.CURVE_ALLOW_ANY)

    key = Key.load('example/broker.key_secret')
    broker = SecureMajorDomoBroker(key, sys.argv[1])
    try:
        broker.serve_forever()
    except KeyboardInterrupt:
        auth.stop()
        raise

if __name__ == '__main__':
    main()
