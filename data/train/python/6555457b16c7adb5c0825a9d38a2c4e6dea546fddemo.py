#!/usr/bin/env python
# vim: ai ts=4 sts=4 et sw=4

import logging, threading, sys
from time import sleep

from rabbitsms.lib.importlib import import_module

BROKER_ENGINE = "rabbitsms.brokers.kombu"
BROKER_HOST = "localhost"
BROKER_PORT = 5672
BROKER_USER = "rabbitsms"
BROKER_PASSWORD = "rabbitsms"
BROKER_VHOST = "rabbitsms"

SMS_BACKENDS = {
    'orange': {
        'ENGINE': 'rabbitsms.backends.gammu',
    }
}


def setup_logging():
    root_logger = logging.getLogger('')
    root_logger.setLevel(logging.DEBUG)
    root_logger_handler = logging.StreamHandler(sys.stdout)
    root_logger_handler.setFormatter(logging.Formatter('%(asctime)s - ' \
                                                       '%(levelname)s ' \
                                                       '- %(message)s'))
    root_logger.addHandler(root_logger_handler)


if __name__ == '__main__':
    setup_logging()

    broker = {'engine': BROKER_ENGINE,
              'host': BROKER_HOST,
              'port': BROKER_PORT,
              'user': BROKER_USER,
              'password': BROKER_PASSWORD,
              'vhost': BROKER_VHOST}

    threads = []

    for name, config in SMS_BACKENDS.iteritems():
        engine_module = import_module(config['ENGINE'])
        thread = engine_module.BackendThread({'name': name, 'broker': broker})
        thread.start()
        threads.append(thread)

    try:
        while True:
            sleep(1)
    except KeyboardInterrupt:
        for thread in threads:
            thread.kill()

