"""packet.py: Raw packet object."""

import struct
from moteconnection.connection import Dispatcher

import logging
log = logging.getLogger(__name__)


__author__ = "Raido Pahtma"
__license__ = "MIT"


class Packet(object):

    def __init__(self, dispatch=0):
        self._dispatch = dispatch
        self._payload = ""
        self.callback = None

    @property
    def dispatch(self):
        return self._dispatch

    @dispatch.setter
    def dispatch(self, dispatch):
        self._dispatch = dispatch

    @property
    def payload(self):
        return self._payload

    @payload.setter
    def payload(self, payload):
        self._payload = payload

    def serialize(self):
        return struct.pack("! B", self._dispatch) + self._payload

    def __str__(self):
        return "[{0._dispatch:02X}]{1:s}".format(self, self._payload.encode("hex").upper())

    @staticmethod
    def deserialize(data):
        if len(data) == 0:
            raise ValueError("At least 1 byte is required to deserialize a Packet!")
        p = Packet(dispatch=ord(data[0]))
        p.payload = data[1:]
        return p


class PacketDispatcher(Dispatcher):

    def __init__(self, dispatch):
        super(PacketDispatcher, self).__init__(dispatch)
        self._receiver = None

    def send(self, packet):
        packet.dispatch = self.dispatch
        self._sender(packet)

    def register_receiver(self, receiver):
        self._receiver = receiver

    def receive(self, data):
        try:
            p = Packet.deserialize(data)
            if self._receiver is not None:
                self._receiver(p)
        except ValueError:
            log.warning("Failed to deserialize packet {}".format(data.encode("hex").upper()))
