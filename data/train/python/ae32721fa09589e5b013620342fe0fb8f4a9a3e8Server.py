#!/usr/bin/python -u
# -*- mode:python; coding:utf-8; tab-width:4 -*-

import sys

import Ice
Ice.loadSlice('factorial.ice')
import Example

from work_queue import WorkQueue


class MathI(Example.Math):
    def __init__(self, work_queue):
        self.work_queue = work_queue

    def factorial_async(self, cb, value, current=None):
        self.work_queue.add(cb, value)


class Server(Ice.Application):
    def run(self, argv):
        work_queue = WorkQueue()
        servant = MathI(work_queue)

        broker = self.communicator()

        adapter = broker.createObjectAdapter("MathAdapter")
        print adapter.add(servant, broker.stringToIdentity("math1"))
        adapter.activate()

        work_queue.start()

        self.shutdownOnInterrupt()
        broker.waitForShutdown()

        work_queue.destroy()
        return 0

sys.exit(Server().main(sys.argv))
