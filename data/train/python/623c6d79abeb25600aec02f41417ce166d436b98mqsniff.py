
import sys
import uuid
import logging

import argparse
from carrot.connection import BrokerConnection
from carrot.messaging import Publisher, Consumer

parser = argparse.ArgumentParser(description="Read a text stream and send it to an AMQP broker")

parser.add_argument("hostname", help="Hostname of the AMQP broker")
parser.add_argument("exchange", help="Exchange to use on the AMQP broker")
parser.add_argument("-v", "--vhost", help="Virtual host to use on the AMQP broker", default="/")
parser.add_argument("-u", "--user", help="User for the AMQP broker", default="guest")
parser.add_argument("-p", "--password", help="Password for the AMQP broker", default="guest")

def main():
    logging.basicConfig(level=logging.INFO)
    args = parser.parse_args()
    conn = BrokerConnection(
            hostname=args.hostname,
            virtual_host=args.vhost,
            userid=args.user,
            password=args.password,
    )
    consumer = Consumer(
            auto_declare    = False,
            connection      = conn,
            exclusive       = True,
            auto_delete     = True,
    )
    try:
        logging.info("Creating exchange: %s" % args.exchange)
        consumer.backend.exchange_declare(exchange=args.exchange, type="topic", durable=False, auto_delete=True)
    except Exception, e:
        logging.warning("Failed to create exchange: %s" % e)
    queue_name = uuid.uuid4().hex
    logging.info("Creating queue: %s" % queue_name)
    consumer.backend.queue_declare(queue=queue_name, durable=False, exclusive=True, auto_delete=True)
    logging.info("Binding queue to exchange: %s" % args.exchange)
    consumer.backend.queue_bind(queue=queue_name, exchange=args.exchange, routing_key="#")
    def dump_message(data, msg):
        print str(data)
    consumer.register_callback(dump_message)
    logging.info("Waiting for messages")
    consumer.wait()
