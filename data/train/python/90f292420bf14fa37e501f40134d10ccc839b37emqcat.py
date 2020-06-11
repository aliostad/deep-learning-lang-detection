#!/usr/bin/env python

import sys
import logging

import argparse
from carrot.connection import BrokerConnection
from carrot.messaging import Publisher, Consumer

parser = argparse.ArgumentParser(description="Read a text stream and send it to an AMQP broker")

parser.add_argument("hostname", help="Hostname of the AMQP broker")
parser.add_argument("exchange", help="Exchange to use on the AMQP broker")
parser.add_argument("--key", help="Routing key to use on the AMQP broker")
parser.add_argument("-v", "--vhost", help="Virtual host to use on the AMQP broker", default="/")
parser.add_argument("-u", "--user", help="User for the AMQP broker", default="guest")
parser.add_argument("-p", "--password", help="Password for the AMQP broker", default="guest")

def main():
    logging.basicConfig(level=logging.DEBUG)
    args = parser.parse_args()
    conn = BrokerConnection(
            hostname=args.hostname,
            virtual_host=args.vhost,
            userid=args.user,
            password=args.password,
    )
    publisher = Publisher(
            auto_declare    = False,
            connection      = conn,
            exchange        = args.exchange,
            routing_key     = args.key
    )
    logging.info("Declaring exchange: %s" % args.exchange)
    publisher.backend.exchange_declare(exchange=args.exchange, type="topic", durable=False, auto_delete=False)
    while True:
        line = sys.stdin.readline()
        if not line:
            break
        logging.debug("Sending message '%s'" % line.strip())
        publisher.send(line.strip())
    publisher.close()
