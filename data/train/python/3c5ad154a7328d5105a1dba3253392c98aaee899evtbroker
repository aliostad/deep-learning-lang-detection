#!/usr/bin/python

import os
import sys
import argparse
import signal
import logging

import zmq
from zmq.eventloop import ioloop
from zmq.eventloop.zmqstream import ZMQStream

from zmqevt.broker import Broker
import zmqevt.defaults as defaults

def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument('--sub', '-s', default=defaults.broker_sub_uri)
    p.add_argument('--pub', '-p', default=defaults.broker_pub_uri)
    p.add_argument('--debug', action='store_true')
    p.add_argument('patterns', nargs='*', default=[''])
    return p.parse_args()

def main():
    opts = parse_args()

    logging.basicConfig(
            level=logging.DEBUG if opts.debug else logging.INFO)
    logging.info('Broker starting up.')

    Broker(pub_uri=opts.pub, sub_uri=opts.sub, patterns=opts.patterns)

    signal.signal(signal.SIGINT,
            lambda sig,frame: ioloop.IOLoop.instance().stop())
    ioloop.install()
    ioloop.IOLoop.instance().start()

if __name__ == '__main__':
    main()

