import pdb
import unittest

from plane import Location
from abstract_node import Node
from messages import Message, MessageBroker, DirectMessage, BroadcastMessage

class TestMessages(unittest.TestCase):

    def setUp(self):
        self.location_a = Location(5, 3)
        self.node_a = Node(node_id="1", location=self.location_a)
        self.arguments_a = {'arg_1':1, 'arg_2':2, 'arg_3':3}
        self.message_a = Message(sender=self.node_a, emit_location=self.location_a, \
                                          function_to_call=self.an_example_function, arguments=self.arguments_a)

        self.location_b = Location(1, 2)
        self.message_b = Message(sender=self.node_a, emit_location=self.location_b, \
                                          function_to_call=self.an_example_function, arguments=self.arguments_a)

        self.message_broker = MessageBroker()

    def test_message_to_be_transmitted_list_empty(self):
        self.assert_(self.message_broker.still_msgs_to_be_transmitted())
        self.message_broker.add_to_be_transmitted(self.message_a)
        self.assertFalse(self.message_broker.still_msgs_to_be_transmitted())

        message = self.message_broker.get_message_to_be_transmitted()
        self.assertTrue(message)
        self.assertTrue(self.message_broker.still_msgs_to_be_transmitted())

    def test_message_to_transmitt_addition_and_get(self):
        self.message_broker.add_to_be_transmitted(self.message_a)
        message = self.message_broker.get_message_to_be_transmitted()
        self.assertEqual(message, self.message_a)

        self.message_broker.add_to_be_transmitted(self.message_b)
        message = self.message_broker.get_message_to_be_transmitted()
        self.assertEqual(message, self.message_b)

    def test_asynchronous_message_reset(self):
        self.assert_(self.message_broker.still_msgs_to_be_transmitted())
        self.message_broker.add_to_be_transmitted(self.message_a)
        self.assertFalse(self.message_broker.still_msgs_to_be_transmitted())

        self.message_broker.add_to_be_transmitted(self.message_b)
        message = self.message_broker.get_message_to_be_transmitted()
        self.assertEqual(message, self.message_b)

        self.message_broker.reset_messages_to_transmit()
        self.assertTrue(self.message_broker.still_msgs_to_be_transmitted())

    def test_direct_message(self):
        node_b = Node(node_id="2", location=self.location_b)
        destination_list = [node_b.id]

        direct_message = DirectMessage(sender=self.node_a, emit_location=self.location_a, function_to_call=self.an_example_function,
                                                     arguments={}, destination_list=destination_list)

        self.assertEqual(direct_message.destination_list, destination_list)

        ret = direct_message.run(all_nodes={self.node_a.id:self.node_a, node_b.id:node_b}, plane=None)

        self.assertFalse(ret['messages'])
        self.assertFalse(ret['asynchronous'])
        self.assertFalse(ret['simulator'])

    def test_broadcast_message(self):
        destination_list = [2]
        node_with_power = Node(node_id="1", location=self.location_a, power=10)

        broadcast_message = BroadcastMessage(sender=node_with_power, emit_location=self.location_a, function_to_call=TestMessages.an_example_function,
                                                     arguments={})

        self.assertEqual(broadcast_message.power, 10)

    def an_example_function(self, another):
        return {'messages':[], 'asynchronous':[], 'simulator':[]}

if __name__ == '__main__':
    unittest.main()
