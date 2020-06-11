#!/usr/bin/python
# (c) Nelen & Schuurmans.  GPL licensed.

from pika import BlockingConnection
from pika import ConnectionParameters
from pika import PlainCredentials

from django.conf import settings

import logging
log = logging.getLogger('flooding.broker')


class BrokerConnection(object):

    def __init__(self):
        self.host = settings.BROKER_SETTINGS.get("BROKER_HOST", '')
        self.port = settings.BROKER_SETTINGS.get("BROKER_PORT", '')
        self.virtual_host = settings.BROKER_SETTINGS.get("BROKER_VHOST", '')
        self.user = settings.BROKER_SETTINGS.get("BROKER_USER", '')
        self.password = settings.BROKER_SETTINGS.get("BROKER_PASSWORD", '')
        self.heartbeat = settings.BROKER_SETTINGS.get("HEARTBEAT", '')

    def connect_to_broker(self):
        """Returns connection object,
        """
        try:
            credentials = PlainCredentials(self.user, self.password)
            parameters = ConnectionParameters(host=self.host,
                                              port=self.port,
                                              virtual_host=self.virtual_host,
                                              credentials=credentials,
                                              heartbeat=self.heartbeat)
            connection = BlockingConnection(parameters)
            return connection
        except Exception as ex:
            log.error("{0}".format(ex))
