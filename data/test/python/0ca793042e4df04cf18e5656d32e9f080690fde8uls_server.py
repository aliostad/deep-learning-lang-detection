#!/usr/bin/env python

import os
from twisted.internet.protocol import DatagramProtocol
from twisted.internet import reactor, threads
import celery


SERVICE_PORT = int(os.environ.get('uls_service_port', 19680))
BATCH_CUTOFF = int(os.environ.get('uls_batch_cutoff', 3))
CELERY_TASK_NAME = os.environ.get('uls_celery_task_name', 'mmf.core.tasks.update_user_last_seen_task')
CELERY_QUEUE = os.environ.get('uls_celery_queue', 'update_user_last_login')


class CeleryConfig(object):
    BROKER_HOST = os.environ.get('uls_broker_host', 'localhost')
    BROKER_PORT = int(os.environ.get('uls_broker_port', 5672))
    BROKER_USER = os.environ.get('uls_broker_usr', 'guest')
    BROKER_PASSWORD = os.environ.get('uls_broker_password', 'guest')
    BROKER_VHOST = os.environ.get('uls_broker_vhost', '/')
    CELERY_ROUTES = {
        CELERY_TASK_NAME: {'queue': CELERY_QUEUE},
    }    


mmf_celery = celery.Celery()
mmf_celery.config_from_object(CeleryConfig)


def celery_task_errback(error):
    raise error


def send_celery_task(batch):    
    print str(batch)
    d = threads.deferToThread(mmf_celery.send_task,
                              CELERY_TASK_NAME, [batch]) 
    d.addErrback(celery_task_errback)


class ReceiveULSPacket(DatagramProtocol):
    def __init__(self):
        self.current_batch = {}

    def datagramReceived(self, datagram, address):
        items = datagram.split('\n')
        entry = {}
        for item in items:
            if ':' not in item:
                continue
            key, value = item.split(':', 1)
            entry[key] = value
        user_id = entry.pop('user_id', None)
        if user_id:
            self.current_batch[user_id] = entry
        if len(self.current_batch) > BATCH_CUTOFF:
            batch = self.current_batch
            self.current_batch = {}
            send_celery_task(batch)


if __name__ == '__main__':
    reactor.listenUDP(SERVICE_PORT, ReceiveULSPacket())
    reactor.run()
