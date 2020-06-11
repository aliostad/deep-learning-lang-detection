__author__ = 'bretmattingly'
import sys
sys.path.append('..')
import unittest
from lib import dispatch
from lib import messages
from lib import errors
from lib.decoding import decode as message_decode


class TestAwaitbox(unittest.TestCase):

    def setUp(self):
        self.dispatch = dispatch.Dispatch(0, ("0.0.0.0", 12358))

    def test_awaitbox_add(self):
        self.dispatch._awaitbox.add(messages.Action(True, 0, 0, 15, 13, 420, 8008))
        self.assertEqual(len(self.dispatch._awaitbox.buckets[0]), 1)

    def test_awaitbox_shift(self):
        self.dispatch._awaitbox.buckets[0][0] = messages.Action(True, 0, 0, 15, 13, 420, 8008)
        lost = self.dispatch._awaitbox.shift()
        self.assertEqual(len(self.dispatch._awaitbox.buckets[0]), 0)
        self.assertEqual(len(self.dispatch._awaitbox.buckets[1]), 1)
        self.assertEqual(len(lost), 0)

    def test_awaitbox_fullshift(self):
        self.dispatch._awaitbox.buckets[0][0] = messages.Action(True, 0, 0, 15, 13, 420, 8008)
        self.dispatch._awaitbox.buckets[1][11] = messages.Action(True, 0, 11, 17, 13, 420, 8008)
        self.dispatch._awaitbox.buckets[2][13] = messages.Action(True, 0, 13, 19, 220, 420, 8008)
        lost = self.dispatch._awaitbox.shift()
        self.assertEqual(len(self.dispatch._awaitbox.buckets[0]), 0, msg='{0}'.format(self.dispatch._awaitbox.buckets[0]))
        self.assertEqual(len(self.dispatch._awaitbox.buckets[1]), 1, msg='{0}'.format(self.dispatch._awaitbox.buckets[1]))
        self.assertEqual(len(self.dispatch._awaitbox.buckets[2]), 1, msg='{0}'.format(self.dispatch._awaitbox.buckets[2]))
        self.assertEqual(len(lost), 1, msg='{0}'.format(lost))

    def test_awaitbox_acknowledge(self):
        self.dispatch._awaitbox.add(messages.Action(True, 0, 0, 15, 13, 420, 8008))
        #  Since add() already tested, theoretically redundant
        self.assertEqual(len(self.dispatch._awaitbox.buckets[0]), 1, msg='{0}'.format(self.dispatch._awaitbox.buckets[0]))
        self.dispatch._awaitbox.acknowledge(0)
        self.assertEqual(len(self.dispatch._awaitbox.buckets[0]), 0, msg='{0}'.format(self.dispatch._awaitbox.buckets[0]))

    def test_awaitbox_pull_resend(self):
        self.dispatch._awaitbox.add(messages.Action(True, 0, 0, 15, 13, 420, 8008))
        resend = self.dispatch._awaitbox.pull_resend(1)
        self.assertEqual(len(resend), 1)

    def tearDown(self):
        self.dispatch._threader.sock.close()
        del self.dispatch


class TestThreader(unittest.TestCase):

    #  Could theoretically test this by switching the
    #  thread's output sockets to files or stdin/stdout?

    def setUp(self):
        self.dispatch = dispatch.Dispatch(0, ("0.0.0.0", 12358))

    def tearDown(self):
        self.dispatch._threader.sock.close()
        del self.dispatch


class TestDispatch(unittest.TestCase):

    def setUp(self):
        self.dispatch = dispatch.Dispatch(0, ("0.0.0.0", 12358))

    def test_dispatch_add_message(self):
        self.dispatch.add_message(messages.Action(True, 0, 0, 15, 13, 420, 8008))
        new_msg = self.dispatch._outbox.get()
        self.assertTrue(type(new_msg) == messages.Action)

    def tearDown(self):
        self.dispatch._threader.sock.close()
        del self.dispatch


