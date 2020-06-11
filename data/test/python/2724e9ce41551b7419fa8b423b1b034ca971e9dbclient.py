# Majordomo Protocol Client API
#
# Implements the MDP/Client spec at http:#rfc.zeromq.org/spec:7
#
# Author: Min RK <benjaminrk@gmail.com>
# Based on Java exmple by Arkadiusz Orzechowski
# Copyright (c) 2010-2011 iMatix Corporation and Contributors

import logging

import zmq

from mdbase.constants import C_CLIENT
from mdbase.utils import dump

class MajorDomoClient(object):
    """Majordomo Protocol Client API

    Implements the MDP/Client spec http:#rfc.zeromq.org/spec:7
    """
    broker = None
    ctx = None
    client = None
    poller = None
    timeout = 2500
    verbose = False

    def __init__(self, broker, verbose=False):
        self.broker = broker
        self.verbose = verbose
        self.ctx = zmq.Context()
        self.poller = zmq.Poller()
        logging.basicConfig(
            format="%(asctime)s %(message)s",
            datefmt="%Y-%m-%d %H:%M:%S",
            level=logging.INFO
        )
        self.reconnect_to_broker()

    def reconnect_to_broker(self):
        """Connect or reconnect to broker"""
        if self.client:
            self.poller.unregister(self.client)
            self.client.close()
        self.client = self.ctx.socket(zmq.DEALER)
        self.client.linger = 0
        self.client.connect(self.broker)
        self.poller.register(self.client, zmq.POLLIN)
        if self.verbose:
            logging.info("I: connecting to broker at %s..." % self.broker)

    def send(self, service, request):
        """Send request to broker"""
        if not isinstance(request, list):
            request = [request]

        # Prefix request qwith protocol frames
        # Frame 0: empty (REQ emulation)
        # Frame 1: "MDPCxy" (six bytes, MDP/Client x.y)
        # Frame 2: Service name (printable string)
        request = ['', C_CLIENT, service] + request
        if self.verbose:
            logging.warn("I: send request to '%s' service: ", service)
            dump(request)
        self.client.send_multipart(request)

    def recv(self):
        """Returns the reply message or None if there was no reply"""
        try:
            items = self.poller.poll(self.timeout)
        except KeyboardInterrupt:
            return # interrupted

        if items:
            msg = self.client.recv_multipart()
            if self.verbose:
                logging.info("I: received reply: ")
                dump(msg)

            # Don't try to handle errors, just assert noisily
            assert len(msg) >= 4

            empty = msg.pop(0)
            assert empty == ''
            header = msg.pop(0)
            assert C_CLIENT == header

            # pop service part of message off
            msg.pop(0)

            return msg
        else:
            logging.warn("W: permanent error, abandoning request")
