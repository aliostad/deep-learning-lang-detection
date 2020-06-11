from module.module import RiemannBroker, get_instance
from shinken.objects.module import Module
import riemann_client.transport

import unittest


class TestRiemannBroker(unittest.TestCase):

    def setUp(self):

        self.basic_modconf = Module(
            {
                'module_name': 'riemannBroker',
                'module_type': 'riemannBroker',
            }
        )
        self.broker = RiemannBroker(self.basic_modconf)
        self.broker.use_udp = True
        self.broker.init()

    def test_get_instance(self):
        result = get_instance(self.basic_modconf)
        self.assertTrue(type(result) is RiemannBroker)

    def test_init(self):
        modconf = Module(
            {
                'module_name': 'influxdbBroker',
                'module_type': 'influxdbBroker',
                'host': 'testhost',
                'port': '1111',
                'tick_limit': '3333',
                'use_udp': '1'
            }
        )

        broker = RiemannBroker(modconf)

        self.assertEqual(broker.host, 'testhost')
        self.assertEqual(broker.port, 1111)
        self.assertEqual(broker.tick_limit, 3333)
        self.assertEqual(broker.use_udp, True)

    def test_init_defaults(self):
        broker = RiemannBroker(self.basic_modconf)

        self.assertEqual(broker.host, 'localhost')
        self.assertEqual(broker.port, 5555)
        self.assertEqual(broker.tick_limit, 300)
        self.assertEqual(broker.use_udp, False)

    def test_transport_modes(self):
        #If use_udp is set, we should use UDPTransport
        broker = RiemannBroker(self.basic_modconf)
        broker.use_udp = True
        broker.init()
        self.assertTrue(
            type(broker.client.transport) is riemann_client.transport.UDPTransport
        )

    def test_get_check_result_perfdata_events(self):
        perf_data = 'ramused=1009MB;;;0;1982 memused=1550GB;2973;3964;0;5810'
        result = self.broker.get_check_result_perfdata_events(perf_data, 1234567890, 'testhost', 'testservice')

        #There must be two metrics, ramused and memused.
        self.assertEqual(len(result), 2)

        #Check the first metric (ramused)
        self.assertEqual(result[0].time, 1234567890)
        self.assertEqual(result[0].service, 'testservice')
        self.assertEqual(result[0].host, 'testhost')
        self.assertEqual(result[0].description, 'ramused')
        self.assertEqual(result[0].metric_f, 1009)
        self.assertEqual(len(result[0].attributes), 3)
        self.assertEqual(result[0].attributes[0].key, "max")
        self.assertEqual(result[0].attributes[0].value, "1982")
        self.assertEqual(result[0].attributes[1].key, "unit")
        self.assertEqual(result[0].attributes[1].value, "MB")
        self.assertEqual(result[0].attributes[2].key, "min")
        self.assertEqual(result[0].attributes[2].value, "0")

        #Check the second metric (memused)
        self.assertEqual(result[1].description, 'memused')

    def test_get_state_update_points(self):

        #The state changes
        data = {
            'last_chk': 1403618279,
            'state': 'WARNING',
            'last_state': 'CRITICAL',
            'state_type': 'SOFT',
            'last_state_type': 'SOFT',
            'output': 'BOB IS NOT HAPPY',
            'host_name': 'testhost',
            'service_description': 'testservice'
        }
        result = self.broker.get_state_update_points(data)
        event = result[0]
        self.assertEqual(event.time, 1403618279)
        self.assertEqual(event.service, "testservice")
        self.assertEqual(event.host, "testhost")

        self.assertEqual(event.attributes[0].key, "state_type")
        self.assertEqual(event.attributes[0].value, "SOFT")

        self.assertEqual(event.attributes[1].value, "BOB IS NOT HAPPY")
        self.assertEqual(event.attributes[1].key, "output")

        self.assertEqual(event.attributes[2].key, "state")
        self.assertEqual(event.attributes[2].value, "WARNING")

        #the state type changes
        data = {
            'last_chk': 1403618279,
            'state': 'CRITICAL',
            'last_state': 'CRITICAL',
            'state_type': 'HARD',
            'last_state_type': 'SOFT',
            'output': 'BOB IS NOT HAPPY',
            'host_name': 'testhost',
            'service_description': 'testservice'
        }
        result = self.broker.get_state_update_points(data)
        self.assertEqual(len(result), 1)

        #Nothing changes
        data = {
            'last_chk': 1403618279,
            'state': 'CRITICAL',
            'last_state': 'CRITICAL',
            'state_type': 'SOFT',
            'last_state_type': 'SOFT',
            'output': 'BOB IS NOT HAPPY',
            'host_name': 'testhost',
            'service_description': 'testservice'
        }
        result = self.broker.get_state_update_points(data)
        self.assertEqual(len(result), 0)

    def test_hook_tick_limit(self):
        broker = self.broker
        broker.tick_limit = 300
        broker.ticks = 299
        broker.buffer.append('this_wont_work_lol')
        broker.hook_tick(None)
        broker.hook_tick(None)
        self.assertEqual(broker.ticks, 0)
        self.assertEqual(broker.buffer, [])

    #def test_send(self):
    #
    #    transport = riemann_client.transport.TCPTransport('localhost', 5555)
    #    transport.connect()
    #    client = Client(transport)
    #    dic = {
    #        'host': 'THISISHOST',
    #        'time': 1234567890,
    #        'state': 'molle',
    #        'metric_f': 22,
    #        'description': 'thisisthedescription',
    #        'attributes': {'test1': '1111', 'test2': '2222'}
    #    }
    #    event = client.create_event(dic)
    #    client.send_event(event)