#!/usr/bin/env python
import unittest
import gc
import time
import threading
import weakref

from appctl_support import ProcController

PKG = 'appctl'
NAME = 'test_proc_controller'

TEST_CMD = ['sleep', '5']
NUM_THREADS_TO_TEST = 8


class StateFlipper(threading.Thread):
    """Rapidly flips a controller between start() and stop() states"""
    def __init__(self, controller, iterations=100):
        super(StateFlipper, self).__init__()
        self.daemon = False
        self.controller = controller
        self.iterations = iterations
        self.failed = False

    def run(self):
        methods = [self.controller.start, self.controller.stop]
        for i in range(self.iterations):
            method = methods[i % 2]
            try:
                method()
            except:
                self.failed = True
                break


class TestProcController(unittest.TestCase):
    def setUp(self):
        self.controller = ProcController(TEST_CMD)

    def tearDown(self):
        self.controller.stop()

    def test_start_and_stop(self):
        self.assertFalse(self.controller.started,
                         'Controller must not start on init')

        self.controller.start()
        self.assertTrue(self.controller.started,
                        'Controller must be started on start()')

        # Wait for the process to spin up
        time.sleep(0.1)

        watcher = self.controller.watcher
        self.assertTrue(watcher.is_alive(),
                        'Process watcher must be alive while started')

        self.controller.stop()
        self.assertFalse(self.controller.started,
                         'Controller must not be started after stop()')

        watcher.join()
        self.assertFalse(watcher.is_alive(),
                         'Process watcher must not be alive after joined')

    def test_concurrency(self):
        flippers = [StateFlipper(self.controller) for i in range(NUM_THREADS_TO_TEST)]
        map(lambda f: f.start(), flippers)
        map(lambda f: f.join(), flippers)
        self.assertFalse(any([f.failed for f in flippers]))

    def test_redundant_start(self):
        self.controller.start()

        watcher = self.controller.watcher

        self.controller.start()

        self.assertIs(watcher, self.controller.watcher,
                      'Stray process watcher on redundant start')

    def test_respawn_flag_forward_to_runner(self):
        """
        Test forwarding of the respawn flag setting and associated
        behaviour. Both for True (default value) and False from the
        higher-lever proc_controller POV.

        """
        self.assertTrue(self.controller.respawn, "The 'respawn' flag is by default True.")
        self.controller.start()
        self.assertTrue(self.controller.watcher.respawn, "The 'respawn' flag is by default True.")
        self.controller.stop()
        time.sleep(0.1)
        self.controller = ProcController(TEST_CMD, respawn=False)
        self.assertFalse(self.controller.respawn, "The 'respawn' flag is False now.")
        self.controller.start()
        self.assertFalse(self.controller.watcher.respawn, "The 'respawn' flag is False now.")
        self.controller.stop()
        time.sleep(0.1)


class TestCleanup(unittest.TestCase):
    def setUp(self):
        self.controller = ProcController(TEST_CMD)

    def test_cleanup_started(self):
        c_ref = weakref.ref(self.controller)
        self.controller.start()
        w_ref = weakref.ref(self.controller.watcher)
        self.controller = None
        gc.collect()
        self.assertIsNone(c_ref())
        time.sleep(0.5)
        self.assertIsNone(w_ref())

    def test_cleanup_stopped(self):
        c_ref = weakref.ref(self.controller)
        self.controller.start()
        w_ref = weakref.ref(self.controller.watcher)
        time.sleep(0.5)
        self.controller.stop()
        self.controller = None
        gc.collect()
        self.assertIsNone(c_ref())
        time.sleep(0.5)
        self.assertIsNone(w_ref())

    def test_close_started(self):
        c_ref = weakref.ref(self.controller)
        self.controller.start()
        w_ref = weakref.ref(self.controller.watcher)
        self.controller.close()
        gc.collect()
        time.sleep(0.5)
        self.assertIsNone(w_ref())

    def test_close_stopped(self):
        c_ref = weakref.ref(self.controller)
        self.controller.start()
        w_ref = weakref.ref(self.controller.watcher)
        time.sleep(0.5)
        self.controller.stop()
        self.controller.close()
        gc.collect()
        time.sleep(0.5)
        self.assertIsNone(w_ref())


if __name__ == '__main__':
    import rostest
    rostest.rosrun(PKG, NAME, TestProcController)
    rostest.rosrun(PKG, NAME, TestCleanup)

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
