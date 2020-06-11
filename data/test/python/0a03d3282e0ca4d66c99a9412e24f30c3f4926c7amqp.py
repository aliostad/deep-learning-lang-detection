# Copyright (c) 2010 Alon Swartz <alon@turnkeylinux.org> - all rights reserved

"""
Environment variables:

    BROKER_HOST         default: localhost
    BROKER_PORT         default: 5672
    BROKER_USER         default: guest
    BROKER_PASSWORD     default: guest
    BROKER_VHOST        default: /
"""

import os
import base64
import simplejson as json
from datetime import datetime

from carrot.connection import BrokerConnection
from carrot.messaging import Publisher, Consumer

from crypto import encrypt, decrypt

class Error(Exception):
    pass

class Connection:
    def __init__(self, hostname, port, vhost, userid, password):
        """connects to broker and provides convenience methods"""
        self.broker = BrokerConnection(hostname=hostname, port=port,
                                       userid=userid, password=password,
                                       virtual_host=vhost)
    
    def __del__(self):
        self.broker.close()

    def declare(self, exchange, exchange_type, binding="", queue=""):
        """declares the exchange, the queue and binds the queue to the exchange
        
        exchange        - exchange name
        exchange_type   - direct, topic, fanout
        binding         - binding to queue (optional)
        queue           - queue to bind to exchange using binding (optional)
        """
        if (binding and not queue) or (queue and not binding):
            if queue and not exchange_type == "fanout":
                raise Error("binding and queue are not mutually exclusive")

        consumer = Consumer(connection=self.broker,
                            exchange=exchange, exchange_type=exchange_type,
                            routing_key=binding, queue=queue)
        consumer.declare()
        consumer.close()

    def consume(self, queue, limit=None, callback=None, auto_declare=False):
        """consume messages in queue
        
        queue           - name of queue
        limit           - amount of messages to iterate through (default: no limit)

        callback        - method to call when a new message is received
                          must take two arguments: message_data, message
                          must send the acknowledgement: message.ack()
                          default: print message to stdout and send ack

        auto_declare    - automatically declare the queue (default: false)
        """
        if not callback:
            callback = _consume_callback

        consumer = Consumer(connection=self.broker, queue=queue,
                            auto_declare=auto_declare)

        consumer.register_callback(callback)
        for message in consumer.iterqueue(limit=limit, infinite=False):
            consumer.receive(message.payload, message)

        consumer.close()

    def publish(self, exchange, routing_key, message,
                auto_declare=False, persistent=True):
        """publish a message to exchange using routing_key
        
        exchange        - name of exchange
        routing_key     - interpretation of routing key depends on exchange type
        message         - message content to send
        auto_declare    - automatically declare the exchange (default: false)
        persistent      - store message on disk as well as memory (default: True)
        """
        delivery_mode = 2
        if not persistent:
            delivery_mode = 1

        publisher = Publisher(connection=self.broker,
                              exchange=exchange, routing_key=routing_key,
                              auto_declare=auto_declare)

        publisher.send(message, delivery_mode=delivery_mode)
        publisher.close()

def _consume_callback(message_data, message):
    """default consume callback if not specified"""
    print message_data
    message.ack()

def connect():
    """convenience method using environment variables"""
    BROKER_HOST = os.getenv('BROKER_HOST', 'localhost')
    BROKER_PORT = os.getenv('BROKER_PORT', 5672)
    BROKER_USER = os.getenv('BROKER_USER', 'guest')
    BROKER_PASSWORD = os.getenv('BROKER_PASSWORD', 'guest')
    BROKER_VHOST = os.getenv('BROKER_VHOST', '/')

    return Connection(BROKER_HOST, BROKER_PORT, BROKER_VHOST,
                      BROKER_USER, BROKER_PASSWORD)


def encode_message(sender, content, secret=None):
    """encode message envelope
    args
    - sender            message sender
    - content           message content
    - secret            secret key to encrypt message (default: None)

    returns message envelope (dict)
    - sender            message sender
    - content           message content (encrypted if secret key is specified)
    - encrypted         boolean flag if content is encrypted
    - timestamp-utc     datetime.utcnow() in list format
    """
    encrypted = False
    timestamp = datetime.utcnow().strftime("%Y %m %d %H %M %S").split()

    content = json.dumps(content)

    if secret:
        encrypted = True
        content = encrypt(content, secret)

    message = {'sender': sender,
               'encrypted': encrypted,
               'content': base64.urlsafe_b64encode(content),
               'timestamp-utc': timestamp}

    return message

def decode_message(message_data, secret=None):
    """decode message envelope
    args
    - message_data      encoded message envelope (see encode_message)
    - secret            secret key to decrypt message (if encrypted)

    returns (sender, content, timestamp)
    - sender            message sender
    - content           content string (plaintext)
    - timestamp         datetime instance
    """
    sender = str(message_data['sender'])
    content = base64.urlsafe_b64decode(str(message_data['content']))
    timestamp = datetime(*map(lambda f: int(f), message_data['timestamp-utc']))

    if message_data['encrypted']:
        content = decrypt(content, secret)

    content = json.loads(content)
    return sender, content, timestamp

