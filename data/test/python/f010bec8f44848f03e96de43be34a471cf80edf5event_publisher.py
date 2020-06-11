# -*- coding: utf-8 -*-

import argparse
from infrabbitmq import factory
import infcommon
import os

parser = argparse.ArgumentParser()
parser.add_argument('-d', '--destination_exchange', action='store', required=True, help='')
parser.add_argument('-e', '--event_name', action='store', default='events', help='')
parser.add_argument('-n', '--network', action='store', default=infcommon.local_net_name(), help='')
parser.add_argument('-o', '--operations', action='store_true', default=False, help='Publish to operations broker')
parser.add_argument("data")
args = parser.parse_args()


if args.operations:
    broker_uri = os.environ['OPERATIONS_BROKER_URI']
else:
    broker_uri = os.environ['BROKER_URI']

rabbitmq_client = factory.event_publisher(args.destination_exchange, broker_uri=broker_uri)
rabbitmq_client.publish(args.event_name, args.network, args.data)
