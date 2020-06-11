''' QPID Broker '''

from tg2.signals.brokers import AbstractBroker
import qpid

class QpidBroker(AbstractBroker):
    """
        QPID specific broker.
    """
    def __init__(self, config):
        broker_conf = config.broker
        self.host = broker_conf.host if hasattr(broker_conf, 'host') else 'localhost'
        self.port = broker_conf.port if hasattr(broker_conf, 'port') else 5672
        self.vhost = broker_conf.virtual_host if hasattr(broker_conf, 'virtual_host') else '/'
        print "Hi I'm a QPID Broker!"
        print " My broker host is: ", self.host
        print " My broker port is: ", self.port
        print " My VHost is: ", self.vhost
broker = QpidBroker
