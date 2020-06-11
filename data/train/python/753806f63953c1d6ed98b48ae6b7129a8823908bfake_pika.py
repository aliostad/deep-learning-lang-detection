import pika
import Queue


_rabbitMQBrokers = dict()


class RabbitMQBroker(object):
    def __init__(self):
        self.exchanges = dict()
        # The following is RabbitMQ's default exchange
        self.exchanges[''] = ExchangeMock(type='fanout')
        self.sendOrderByExchanges = list()


def startFakeRabbitMQBroker(url):
    global _rabbitMQBrokers
    _rabbitMQBrokers[_brokerKeyByURL(url)] = RabbitMQBroker()


def _brokerKeyByURL(url):
    return "%(host)s:%(port)s" % dict(host=url.host, port=url.port)


def stopFakeRabbitMQBroker(url):
    global _rabbitMQBrokers
    del _rabbitMQBrokers[_brokerKeyByURL(url)]


def removeAllBrokers():
    global _rabbitMQBrokers
    rabbitMQBrokers = dict()


def getBrokerInstanceFromURL(url):
    global _rabbitMQBrokers
    return _rabbitMQBrokers[_brokerKeyByURL(url)]


class ExchangeMock(object):
    def __init__(self, type):
        if type != 'fanout':
            raise ValueError("Mock does not support exchange types other than 'fanout'")
        self.exchange_type = type
        self.messages = Queue.Queue()

    def publish(self, message):
        self.messages.put(message)

    def consume(self):
        return self.messages.get()


class BlockingChannelMock(object):
    def __init__(self):
        self.broker = None
        self.exchanges = None
        self.deletedExchanges = dict()

    def setBroker(self, broker):
        self.exchanges = broker.exchanges
        self.broker = broker

    def exchange_declare(self, exchange, type):
        if exchange in self.exchanges:
            existing = self.exchanges[exchange]
            self._validateExchangePropertyIsEqual(type, existing.type)
        self.exchanges[exchange] = ExchangeMock(type=type)

    def exchange_delete(self, exchange):
        assert exchange is not None
        deletedExchange = self.exchanges.pop(exchange)
        self.deletedExchanges[exchange] = deletedExchange

    def basic_publish(self, exchange, routing_key, body):
        if exchange not in self.exchanges:
            raise ValueError(exchange, "Not a declared exchange")
        self.exchanges[exchange].publish(body)
        self.broker.sendOrderByExchanges.append(exchange)

    def basic_consume(self, exchange):
        message = self.exchanges[exchange].consume()
        sendOrder = self.broker.sendOrderByExchanges
        sendOrder.reverse()
        sendOrder.remove(exchange)
        sendOrder.reverse()
        return message

    def _validateExchangePropertyIsTheSame(self, actual, expected):
        if actual != expected:
            raise pika.ChannelClosed()


class BlockingConnectionMock(object):
    def __init__(self, urlParams):
        global rabbitmqBrokers
        try:
            self.broker = getBrokerInstanceFromURL(urlParams)
        except KeyError:
            raise pika.exceptions.AMQPConnectionError()

    def channel(self):
        channel = BlockingChannelMock()
        channel.setBroker(self.broker)
        return channel

    def process_data_events(self):
        pass
