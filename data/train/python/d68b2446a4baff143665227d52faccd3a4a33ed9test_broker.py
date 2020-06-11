import calendar
import time
from datetime import datetime

from utils import KafkaTest
from kafkameta import KafkaBroker

broker_config = {
    'id':  1,
    'host': 'foo.example.com',
    'port': 12345,
    'jmx_port': 1010,
    'timestamp': calendar.timegm(time.gmtime()) * 1000
}
test_broker = KafkaBroker(broker_config['id'], broker_config['host'], broker_config['port'], broker_config['jmx_port'], broker_config['timestamp'])


class KafkaBrokerTest(KafkaTest):
    def test_broker_timestamp(self):
        self.assertTrue(type(test_broker.timestamp) is datetime)

    def test_broker_id(self):
        self.assertTrue(type(test_broker.id) is int)

    def test_broker_port(self):
        self.assertTrue(type(test_broker.port) is int)

    def test_broker_jmx_port(self):
        self.assertTrue(type(test_broker.jmx_port) is int)

    def test_broker_host(self):
        self.assertTrue(type(test_broker.host) is str)
