import unittest
from multiprocessing import Queue, Process
from imp import load_source
from os import path
import events
from uuid import uuid4 as uuid

class TestBroker(unittest.TestCase):
    broker_module_path = path.join('..', 'broker.py')
    broker_test_caching_plugin = 'test_broker_plugin.py'
    broker_test_caching_plugin_name = broker_test_caching_plugin.rsplit('.',1)[0]
    
    def setUp(self):
        self.broker_module = load_source('broker', self.broker_module_path)
        self.rxq = Queue()
        self.txq = Queue()
        self.broker = self.broker_module.Broker(self.rxq, self.txq)
        self.broker_process = Process(target=self.broker.start)
    
    def test_caching(self):
        # load caching test plugin
        self.broker.add_plugin(self.broker_test_caching_plugin_name, self.broker_test_caching_plugin)
        self.broker_process.start()
        # add something to rxq
        unique_value1 = uuid().hex
        msg = events.Unknown(target="caching", msg=unique_value1)
        self.rxq.put(msg)
        
        # add something else to rxq
        unique_value2 = uuid().hex
        msg = events.Unknown(target="caching", msg=unique_value2)
        self.rxq.put(msg)
        
        # see if it can return first value
        test_val = self.txq.get(timeout=2)
        self.assertEquals(unique_value1, test_val)
        self.assertNotEquals(unique_value2, test_val)
         
if __name__ == "__main__":
    unittest.main()