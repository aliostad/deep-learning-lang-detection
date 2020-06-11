# -*- coding: utf-8 -*-
import threading
from carrot.messaging import Publisher
from carrot.connection import BrokerConnection

from conductor.task import Task

__all__ = ['AMQPBrokerTask', 'BrokerPool', 'AMQPBrokerSettings']

class AMQPBrokerSettings(object):
    """
    AMQP connection settings.
    """
    def __init__(self):
        self.hostname = None
        self.port = 5672
        self.username = None
        self.password = None
        self.vhost = "/"

class AMQPBrokerTask(Task):
    def __init__(self, bus=None):
        Task.__init__(self, bus)
        self.settings = AMQPBrokerSettings()
        self.pool_size = 10
        self.pool = None

    def start_task(self):
        self.bus.log("Starting AMQP broker management task")
        self.pool = BrokerPool(self.settings.hostname, self.settings.port,
                               self.settings.username, self.settings.password,
                               self.settings.vhost, self.pool_size)
        with self.pool.lock:
            pass

        self.bus.subscribe("get-amqp-broker", self.get_broker)
        self.bus.subscribe("release-amqp-broker", self.release_broker)
    start_task.priority = 10
        
    def stop_task(self):
        self.bus.log("Stopping AMQP broker management task")
        self.bus.unsubscribe("get-amqp-broker", self.get_broker)
        self.bus.unsubscribe("release-amqp-broker", self.release_broker)
        self.pool.release_all()
    stop_task.priority = 90

    def get_broker(self):
        return self.pool.get()

    def release_broker(self, broker):
        self.pool.release(broker)

class BrokerPool(object):
    def __init__(self, hostname, port, username, password, vhost, pool_size=10):
        self.lock = threading.Lock()
        
        self.hostname = hostname
        self.port = port
        self.username = username
        self.password = password
        self.vhost = vhost

        self._brokers = []
        self._checkedout_brokers = []

        self.add_many(pool_size)

    def add_many(self, limit):
        with self.lock:
            for _ in range(0, limit):
                broker = BrokerConnection(hostname=self.hostname, port=self.port,
                                          userid=self.username, password=self.password,
                                          virtual_host=self.vhost)
                self._brokers.append(broker)

    def add(self):
        broker = BrokerConnection(hostname=self.hostname, port=self.port,
                                  userid=self.username, password=self.password,
                                  virtual_host=self.vhost)
        with self.lock:
            self._brokers.append(broker)

    def get(self):
        with self.lock:
            broker = self._brokers.pop()
            self._checkedout_brokers.append(broker)
            return broker

    def release(self, broker):
        with self.lock:
            self._brokers.append(broker)
            if broker in self._checkedout_brokers:
                self._checkedout_brokers.remove(broker)

    def release_all(self):
        with self.lock:
            for broker in self._brokers:
                broker.close()
            self._brokers = []

            for broker in self._checkedout_brokers:
                broker.close()
            self._checkedout_brokers = []

if __name__ == "__main__":
    from conductor.process import Process
    from conductor.lib.logger import open_logger
    from conductor.protocol.amqp.broker import AMQPBrokerTask
    from conductor.protocol.amqp.consumer import ConsumerTask
    from conductor.protocol.amqp.publisher import PublisherTask

    class PubSub(Task):
        def __init__(self, bus=None):
            Task.__init__(self, bus)

        def start_task(self):
            self.broker =  self.bus.publish("get-amqp-broker").pop()
            self.publisher = self.bus.publish("get-amqp-publisher", self.broker,
                                              exchange="X", routing_key="K").pop()
            self.consumer = self.bus.publish("get-amqp-consumer", self.broker, queue="Q",
                                             routing_key="K", exchange="X").pop()
            self.bus.subscribe("main", self.pub_and_print)

        def stop_task(self):
            self.bus.unsubscribe("main", self.pub_and_print)
            self.consumer.close()
            self.publisher.close()
            self.bus.publish("release-amqp-broker", broker)

        def pub_and_print(self):
            self.publisher.send("hello")
            self.bus.log(self.consumer.fetch())


    p = Process()
    p.interval = 0
    p.logger = open_logger(stdout=True,
                           logger_name="main")

    t = AMQPBrokerTask()
    t.settings.hostname = "localhost"
    t.settings.username = "test"
    t.settings.password = "test"
    t.settings.vhost = "/"
    p.register_task(t)

    c = ConsumerTask()
    p.register_task(c)

    o = PublisherTask()
    p.register_task(o)

    m = PubSub()
    p.register_task(m)
    
    p.run()
