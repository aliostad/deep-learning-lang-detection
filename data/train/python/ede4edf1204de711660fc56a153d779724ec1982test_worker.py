# -*- coding: utf-8 -*-

"""Unittests for the MDPWorker class.
"""


__license__ = """
    This file is part of MDP.

    MDP is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    MDP is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with MDP.  If not, see <http://www.gnu.org/licenses/>.
"""
__author__ = 'Guido Goldstein'
__email__ = 'gst-py@a-nugget.de'

import sys
import time
import unittest
from pprint import pprint

import zmq
from zmq.eventloop.zmqstream import ZMQStream
from zmq.eventloop.ioloop import IOLoop, DelayedCallback, PeriodicCallback

from worker import MDPWorker, ConnectionNotReadyError, MissingHeartbeat

###

_do_print = True

###

class MyWorker(MDPWorker):

    HB_LIVENESS = 10

    def on_request(self, msg):
        answer = ['REPLY'] + msg
        self.reply(answer)
        return
#
###

class Test_MDPWorker(unittest.TestCase):

    endpoint = b'tcp://127.0.0.1:7777'
    service = b'test'


    def setUp(self):
        print 'set up'
        sys.stdout.flush()
        self.context = zmq.Context()
        self.broker = None
        self._msgs = []
        return

    def tearDown(self):
        print 'tear down'
        sys.stdout.flush()
        if self.broker:
            self._stop_broker()
        self.broker = None
##         self.context.term()
        self.context = None
        return

    def _on_msg(self, msg):
        if _do_print:
            print 'broker received:',
            pprint(msg)
        self.target = msg.pop(0)
        if msg[1] == chr(1): # ready
            print 'READY'
            self.target = msg[0]
            return
        if msg[1] == chr(4): # ready
            print 'HB'
            return
        if msg[1] == chr(3): # reply
            IOLoop.instance().stop()
            return
        return

    def _start_broker(self, do_reply=False):
        """Helper activating a fake broker in the ioloop.
        """
        socket = self.context.socket(zmq.XREP)
        self.broker = ZMQStream(socket)
        self.broker.socket.setsockopt(zmq.LINGER, 0)
        self.broker.bind(self.endpoint)
        self.broker.on_recv(self._on_msg)
        self.broker.do_reply = do_reply
        self.broker.ticker = PeriodicCallback(self._tick, MyWorker.HB_INTERVAL)
        self.broker.ticker.start()
        self.target = None
        return

    def _stop_broker(self):
        if self.broker:
            self.broker.ticker.stop()
            self.broker.ticker = None
            self.broker.socket.close()
            self.broker.close()
            self.broker = None
        return

    def _tick(self):
        if self.broker and self.target:
            msg = [self.target, b'MPDW01', chr(4)]
            self.broker.send_multipart(msg)
        return

    def send_req(self):
        data = ['AA', 'bb']
        msg = [self.target, b'MPDW01', chr(2), self.target, b''] + data
        print 'borker sending:',
        pprint(msg)
        self.broker.send_multipart(msg)
        return

    # tests follow

    def test_01_simple_01(self):
        """Test MDPWorker simple req/reply.
        """
        self._start_broker()
        time.sleep(0.2)
        worker = MyWorker(self.context, self.endpoint, self.service)
        sender = DelayedCallback(self.send_req, 1000)
        sender.start()
        IOLoop.instance().start()
        worker.shutdown()
        self._stop_broker()
        return
#
###

if __name__ == '__main__':
    sys.argv.append('-v')
    unittest.main()
#

### Local Variables:
### buffer-file-coding-system: utf-8
### mode: python
### End:
