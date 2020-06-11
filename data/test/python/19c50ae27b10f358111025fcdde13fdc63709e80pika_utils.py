# coding=utf-8
import pika


BROKER_HOST = 'localhost'
BROKER_PORT = 5672
BROKER_USER = "test"
BROKER_PASSWORD = "test"
BROKER_VHOST = "/"


def get_pika_connection():
    """Set up a connection with a messages broker using pika library."""
    credentials = pika.PlainCredentials(BROKER_USER,
                                        BROKER_PASSWORD)

    parameters = pika.ConnectionParameters(credentials=credentials,
                                           host=BROKER_HOST,
                                           virtual_host=BROKER_VHOST)

    connection = pika.BlockingConnection(parameters)
    return connection


def get_channel(pika_connection, queue):
    """Set up a channel and a queue for a given pika connection."""
    channel = pika_connection.channel()
    channel.queue_declare(queue=queue, durable=True,
                          exclusive=False, auto_delete=False)
    return channel


def publish_message(message, channel, routing_key):
    """Publish a message to a channel with a specific routing key."""
    properties = pika.BasicProperties(content_type="application/json",
                                      delivery_mode=2)
    channel.basic_publish(exchange='',
                          routing_key=routing_key,
                          body=message,
                          properties=properties)
