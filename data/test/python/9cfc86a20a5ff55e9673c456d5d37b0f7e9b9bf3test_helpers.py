from pkg_resources import resource_filename

from mock import patch, sentinel
from yaml import load

from pikachewie.broker import Broker
from pikachewie.helpers import (broker_from_config, consumer_agent_from_config,
                                consumer_from_config)
from tests import _BaseTestCase, LoggingConsumer, unittest

mod = 'pikachewie.helpers'
config = load(open(resource_filename(__name__, 'rabbitmq.yaml')))


class DescribeConsumerFromConfig(unittest.TestCase):

    def setUp(self):
        self.consumer = consumer_from_config(
            config['rabbitmq']['consumers']['message_logger'])

    def should_return_consumer(self):
        self.assertIsInstance(self.consumer, LoggingConsumer)

    def should_pass_arguments_to_init(self):
        self.assertEqual(self.consumer.level, 'debug')


class DescribeBrokerFromConfig(unittest.TestCase):
    connect_options = {
        'virtual_host': '/integration',
        'heartbeat_interval': 60,
    }

    def setUp(self):
        self.broker_config = config['rabbitmq']['brokers']['default']
        self.broker = broker_from_config(self.broker_config)

    def should_return_broker(self):
        self.assertIsInstance(self.broker, Broker)

    def should_set_nodes(self):
        self.assertEqual(dict(self.broker._nodes), self.broker_config['nodes'])

    def should_set_connect_options(self):
        self.assertEqual(self.broker._connect_options, self.connect_options)


class DescribeConsumerAgentFromConfig(_BaseTestCase):
    __contexts__ = (
        ('ConsumerAgent', patch(mod + '.ConsumerAgent',
                                return_value=sentinel.agent)),
        ('consumer_from_config', patch(mod + '.consumer_from_config',
                                       return_value=sentinel.consumer)),
        ('broker_from_config', patch(mod + '.broker_from_config',
                                     return_value=sentinel.broker)),
    )

    def configure(self):
        self.name = 'message_logger'
        self.broker_config = config['rabbitmq']['brokers']['default']
        self.bindings = config['rabbitmq']['consumers'][self.name]['bindings']

    def execute(self):
        self.agent = consumer_agent_from_config(config, 'message_logger')

    def should_create_consumer(self):
        self.ctx.consumer_from_config.assert_called_once_with(
            config['rabbitmq']['consumers'][self.name])

    def should_create_broker(self):
        self.ctx.broker_from_config.assert_called_once_with(self.broker_config)

    def should_create_agent(self):
        self.ctx.ConsumerAgent.assert_called_once_with(sentinel.consumer,
                                                       sentinel.broker,
                                                       self.bindings,
                                                       True,
                                                       config['rabbitmq'])

    def should_return_agent(self):
        self.assertIs(self.agent, sentinel.agent)
