from jolokia_session import JolokiaSession
from remote_jmx_queue import RemoteJmxQueue

class RemoteJmxBroker(object):
    @staticmethod
    def connect(host, port, broker_name):
        jolokia_session = JolokiaSession.connect(host, port)
        return RemoteJmxBroker(jolokia_session, broker_name)

    def __init__(self, jolokia_session, broker_name):
        self.jolokia_session = jolokia_session
        self.broker_name = broker_name

    def add_queue(self, queue_name):
        mbean = 'org.apache.activemq:type=Broker,brokerName={}'.format(self.broker_name)
        operation = {
            'type': 'exec',
            'mbean': mbean,
            'operation': 'addQueue',
            'arguments': [queue_name]
        }
        self.jolokia_session.request(operation)
        return RemoteJmxQueue(self.jolokia_session, self.broker_name, queue_name)
