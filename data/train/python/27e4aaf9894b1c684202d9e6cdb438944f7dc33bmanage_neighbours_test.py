import unittest
import time
import os
import logging
import threading
import json
import random
from fabnet.core import constants
constants.CHECK_NEIGHBOURS_TIMEOUT = 1
from fabnet.core.fri_base import FabnetPacketRequest, FabnetPacketResponse
from fabnet.core.fri_client import FriClient
from fabnet.core.operator import Operator
from fabnet.operations.manage_neighbours import ManageNeighbour
from fabnet.utils.logger import logger

#logger.setLevel(logging.DEBUG)


class TestServerThread(threading.Thread):
    def __init__(self, manage_neighbours):
        threading.Thread.__init__(self)
        self.manage_neighbours = manage_neighbours

    def run(self):
        for i in xrange(100):
            operation = ['append', 'remove'][random.randint(0, 1)]
            node = ['127.0.0.1:1987', '127.0.0.1:1988', '127.0.0.1:1989'][random.randint(0, 2)]
            n_type = random.randint(1, 2)

            if random.randint(0, 1):
                d = {"sender": node, "parameters": {"operator_type":"DHT", "node_address": node, "operation": operation, "neighbour_type": n_type}, "method": "ManageNeighbour"}
                packet = FabnetPacketRequest(**d)
                #print self.manage_neighbours.process(packet).ret_parameters
            else:
                d_append = [True, False][random.randint(0, 1)]
                d_remove = [True, False][random.randint(0, 1)]
                d = {"sender": node, "ret_parameters": {"operator_type":"DHT", "node_address": node, "operation": operation, "neighbour_type": n_type, 'dont_append': d_append, 'dont_remove': d_remove}, "method": "ManageNeighbour"}
                packet = FabnetPacketResponse(**d)
                #print self.manage_neighbours.callback(packet)



def _init_operation_mock(node_address, operation, parameters):
    print node_address, operation, parameters
    return 0, 'ok'


class TestManageMeighbours(unittest.TestCase):
    def test_manage_neighbours(self):
        operator = Operator('127.0.0.1:1986')

        manage_neighbours = ManageNeighbour(operator, FriClient(), '127.0.0.1:1986', '/tmp', None)

        manage_neighbours._init_operation = _init_operation_mock

        threads = []
        for i in xrange(10):
            tst = TestServerThread(manage_neighbours)
            threads.append(tst)

        for thread in threads:
            thread.start()

        for thread in threads:
            thread.join()

        operator.stop()


if __name__ == '__main__':
    unittest.main()

