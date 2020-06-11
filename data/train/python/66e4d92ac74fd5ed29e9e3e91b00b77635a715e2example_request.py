#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Triggers an example AMQP message with Python.
# Start the "example.py" daemon in another shell before running this.
#
from time import sleep
from random import randrange
import json
from carrot.messaging import Consumer, Publisher
from example_broker import ExampleBroker

def request_no_response():
    """No response"""
    data = {'q': 'hello AMQP backend, I am Python'}

    broker = ExampleBroker()
    publisher = Publisher(
        connection = broker.amqp_connection,
        exchange = broker.exchange_name,
        exchange_type = "topic",
        routing_key = broker.binding_key,
        )
    publisher.send(json.dumps(data))

def request_with_response():
    """Example of requesting over AMQP from another process, not necessarily Python."""
    qid = str(randrange(0,999))
    data = {'qid': qid, 'q': 'what time is it?'}

    broker = ExampleBroker()
    publisher = Publisher(
        connection = broker.amqp_connection,
        exchange = broker.exchange_name,
        exchange_type = "topic",
        routing_key = broker.binding_key,
        )
    
    # declare test queue for receiving response message
    backend = broker.amqp_connection.create_backend()
    backend.queue_declare(
        queue="test",
        durable=False,
        exclusive=False,
        auto_delete=True,)
    backend.queue_bind(
        "test",
        broker.exchange_name,
        broker.response_routing_key % qid)
    consumer = Consumer(
        connection=broker.amqp_connection,
        exchange=broker.exchange_name,
        exchange_type="topic",
        queue="test",
        )
    consumer.discard_all()

    # send message
    publisher.send(json.dumps(data))

    # allow data to pass the wire
    sleep(0.2)

    # retrieve response
    response = consumer.fetch()
    payload = json.loads(response.payload)
    print "Response from AMQP: %s" % payload

if __name__ == '__main__':
    request_no_response()
    request_with_response()
