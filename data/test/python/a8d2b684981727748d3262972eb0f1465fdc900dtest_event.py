import pdb
import unittest

from abstract_node import Node

from events import EventBroker, AsynchronousEvent, SimulatorEvent
from plane import Location

class TestEvent(unittest.TestCase):

    def setUp(self):
        location_a = Location(5, 3)
        node_a = Node(node_id="1", location=location_a)
        arguments_a = {'arg_1':1, 'arg_2':2, 'arg_3':3}
        self.asynchronous_event_1 = AsynchronousEvent(node_id=node_a.id, function_to_call=self.an_example_function, arguments=arguments_a)

        location_b = Location(1, 2)
        node_b = Node(node_id="1", location=location_b)
        arguments_b = {'arg_1':5, 'arg_2':4, 'arg_3':3}
        self.asynchronous_event_2 = AsynchronousEvent(node_id=node_b.id, function_to_call=self.an_example_function, arguments=arguments_b)

        self.simulator_event_1 = SimulatorEvent(arguments=arguments_a)
        self.simulator_event_2 = SimulatorEvent(arguments=arguments_b)

        self.event_broker = EventBroker()

    def test_asynchronous_event_list_empty(self):
        self.assert_(self.event_broker.is_asynchronous_events_empty())
        self.event_broker.add_asynchronous_event(self.asynchronous_event_1)
        self.assertFalse(self.event_broker.is_asynchronous_events_empty())
        event = self.event_broker.get_asynchronous_event()
        self.assertTrue(self.event_broker.is_asynchronous_events_empty())

    def test_asynchronous_event_addition_and_get(self):
        self.event_broker.add_asynchronous_event(self.asynchronous_event_1)
        event = self.event_broker.get_asynchronous_event()
        self.assertEqual(event, self.asynchronous_event_1)

        self.event_broker.add_asynchronous_event(self.asynchronous_event_2)
        event = self.event_broker.get_asynchronous_event()
        self.assertEqual(event, self.asynchronous_event_2)

    def test_asynchronous_event_reset(self):
        self.assert_(self.event_broker.is_asynchronous_events_empty())
        self.event_broker.add_asynchronous_event(self.asynchronous_event_1)
        self.assertFalse(self.event_broker.is_asynchronous_events_empty())

        self.event_broker.add_asynchronous_event(self.asynchronous_event_2)
        event = self.event_broker.get_asynchronous_event()
        self.assertEqual(event, self.asynchronous_event_2)

        self.event_broker.reset_asynchronous_events()
        self.assertTrue(self.event_broker.is_asynchronous_events_empty())

    def test_simulator_event_reset(self):
        self.assert_(self.event_broker.is_simulator_events_empty())
        self.event_broker.add_simulator_event(self.simulator_event_1)
        self.assertFalse(self.event_broker.is_simulator_events_empty())

        self.event_broker.add_simulator_event(self.simulator_event_2)
        event = self.event_broker.get_simulator_event()
        self.assertEqual(event, self.simulator_event_2)

        self.event_broker.reset_simulator_events()
        self.assertTrue(self.event_broker.is_simulator_events_empty())

    def test_simulator_event_addition_and_get(self):
        self.event_broker.add_simulator_event(self.simulator_event_1)
        event = self.event_broker.get_simulator_event()
        self.assertEqual(event, self.simulator_event_1)

        self.event_broker.add_simulator_event(self.simulator_event_2)
        event = self.event_broker.get_simulator_event()
        self.assertEqual(event, self.simulator_event_2)

    def an_example_function(self):
        pass
