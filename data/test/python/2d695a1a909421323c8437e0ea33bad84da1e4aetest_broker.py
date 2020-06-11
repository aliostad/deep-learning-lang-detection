from mock import MagicMock, patch, sentinel
from pika import BlockingConnection, PlainCredentials
from pika.adapters.tornado_connection import TornadoConnection
from pika.exceptions import AMQPConnectionError

from pikachewie.broker import Broker
from tests import _BaseTestCase

mod = 'pikachewie.broker'


class _BrokerTestCase(_BaseTestCase):
    __contexts__ = (
        ('_flush_outbound', patch(
            'pika.adapters.base_connection.BaseConnection._flush_outbound')),
        ('tornado_adapter_connect', patch(
            mod + '.TornadoConnection._adapter_connect')),
        ('blocking_adapter_connect', patch(
            mod + '.BlockingConnection._adapter_connect')),
    )
    nodes = {
        'rabbit1': {
            'host': 'rabbit1.example.com',
            'port': 5673,
        },
        'rabbit2': {
            'port': 5674,
        },
        'rabbit3': {
            'host': 'rabbit3.example.com',
        },
        'localhost': {
            'host': '127.0.0.1',
        },
    }
    connect_options = {
        'credentials': PlainCredentials(username=sentinel.username,
                                        password=sentinel.password),
        'virtual_host': '/pikachewie',
        'heartbeat_interval': 60,
    }


class WhenCreatingBrokerWithoutArguments(_BrokerTestCase):

    def execute(self):
        self.broker = Broker()

    def should_use_default_nodes(self):
        self.assertEqual(dict(self.broker._nodes), Broker.DEFAULT_NODES)

    def should_use_default_connect_options(self):
        self.assertEqual(self.broker._connect_options,
                         Broker.DEFAULT_CONNECT_OPTIONS)


class WhenCreatingBrokerWithNodes(_BrokerTestCase):

    def execute(self):
        self.broker = Broker(self.nodes)

    def should_set_nodes(self):
        self.assertEqual(dict(self.broker._nodes), self.nodes)


class WhenCreatingBrokerWithConnectOptions(_BrokerTestCase):

    def execute(self):
        self.broker = Broker(None, self.connect_options)

    def should_set_connect_options(self):
        self.assertEqual(self.broker._connect_options, self.connect_options)


class WhenCreatingBrokerWithCredentialsDict(_BrokerTestCase):
    connect_options = {
        'credentials': {
            'username': sentinel.username,
            'password': sentinel.password,
        },
        'virtual_host': '/pikachewie',
        'heartbeat_interval': 60,
    }

    def execute(self):
        self.broker = Broker(None, self.connect_options)

    def should_create_plain_credentials(self):
        self.assertIsInstance(self.broker._connect_options['credentials'],
                              PlainCredentials)

    def should_set_username(self):
        self.assertEqual(self.broker._connect_options['credentials'].username,
                         sentinel.username)

    def should_set_password(self):
        self.assertEqual(self.broker._connect_options['credentials'].username,
                         sentinel.username)


class _BaseConnectionTestCase(_BrokerTestCase):
    nodes = {'localhost': {'host': '127.0.0.1', 'port': 5673}}
    connection_options = {
        'credentials': {'username': sentinel.username,
                        'password': sentinel.password},
        'virtual_host': '/pikachewie',
        'heartbeat_interval': 60,
    }

    def should_connect_to_expected_host(self):
        self.assertEqual(self.connection.params.host, '127.0.0.1')

    def should_connect_to_expected_port(self):
        self.assertEqual(self.connection.params.port, 5673)

    def should_set_virtual_host(self):
        self.assertEqual(self.connection.params.virtual_host, '/pikachewie')

    def should_set_heartbeat_interval(self):
        self.assertEqual(self.connection.params.heartbeat, 60)

    def should_set_username(self):
        self.assertEqual(self.connection.params.credentials.username,
                         sentinel.username)

    def should_set_password(self):
        self.assertEqual(self.connection.params.credentials.password,
                         sentinel.password)


class WhenGettingAsynchronousConnection(_BaseConnectionTestCase):

    def configure(self):
        self.broker = Broker(self.nodes, self.connect_options)
        self.on_open_callback = MagicMock()

    def execute(self):
        self.connection = self.broker.connect(self.on_open_callback,
                                              stop_ioloop_on_close=True)

    def should_return_connection(self):
        self.assertIsInstance(self.connection, TornadoConnection)

    def should_register_on_open_callback(self):
        self.connection.callbacks.process(0, '_on_connection_open',
                                          sentinel.caller, self.connection)
        self.on_open_callback.assert_called_once_with(self.connection)

    def should_set_stop_ioloop_on_close(self):
        self.assertTrue(self.connection.stop_ioloop_on_close)


class WhenGettingSynchronousConnection(_BaseConnectionTestCase):

    def configure(self):
        self.broker = Broker(self.nodes, self.connect_options)

    def execute(self):
        self.connection = self.broker.connect(blocking=True)

    def should_return_connection(self):
        self.assertIsInstance(self.connection, BlockingConnection)


class WhenEncounteringConnectionErrors(_BaseTestCase):
    __contexts__ = (
        ('TornadoConnection', patch(mod + '.TornadoConnection',
                                    side_effect=[AMQPConnectionError(1),
                                                 AMQPConnectionError(1),
                                                 TornadoConnection])),
    )

    def configure(self):
        self.ctx.TornadoConnection._adapter_connect = MagicMock()
        self.broker = Broker({'rabbit1': {}, 'rabbit2': {}})

    def execute(self):
        self.connection = self.broker.connect(connection_attempts=3)

    def should_try_try_again(self):
        self.assertIsNotNone(self.connection)


class WhenExhaustingConnectionAttempts(_BaseTestCase):
    __contexts__ = (
        ('TornadoConnection', patch(mod + '.TornadoConnection',
                                    side_effect=AMQPConnectionError(1))),
    )

    def setUp(self):
        pass

    def configure(self):
        self.broker = Broker({'rabbit1': {}, 'rabbit2': {}})

    def should_raise_exception(self):
        with self.context() as self.ctx:
            self.configure()
            with self.assertRaisesRegexp(AMQPConnectionError, r'^2$'):
                self.broker.connect()


class WhenExhaustingConnectionAttemptsWithCallback(_BaseTestCase):
    __contexts__ = (
        ('TornadoConnection', patch(mod + '.TornadoConnection',
                                    side_effect=AMQPConnectionError(1))),
        ('BrokerConnectionError', patch(mod + '.BrokerConnectionError',
                                        return_value=sentinel.broker_error))
    )

    def configure(self):
        self.broker = Broker({'rabbit1': {}, 'rabbit2': {}})
        self.on_failure_callback = MagicMock()

    def execute(self):
        self.broker.connect(on_failure_callback=self.on_failure_callback)

    def should_invoke_on_failure_callback(self):
        self.on_failure_callback.assert_called_once_with(sentinel.broker_error)
