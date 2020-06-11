# -*- coding: utf-8 -*-

from __future__ import absolute_import
from celery import Celery, shared_task
from datetime import datetime
from broker.sync_broker import syncBroker, robotBroker
from broker.find_options import findOptions, findOptionsLoop
from settings import *
import os, time

# import pika, logging
# logging.basicConfig()
# try:
#     from celery.task import task
# except ImportError:
#     from celery.decorators import task

# Celery RabitQM Broker configuration for Celery
app = Celery('tasks', backend="amqp", broker='')
# app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)
app.conf.update(
                BROKER_URL = migration.get('BROKER_URL_AMQP') or "amqp://guest:guest@localhost:5672//",
                BROKER_BACKEND = "amqp",
                CELERY_RESULT_BACKEND = "amqp",    # ['database', 'amqp', 'redis://localhost:6379/0']
                BROKER_POOL_LIMIT = 2,
                BROKER_HEARTBEAT = 30,
                CELERY_TASK_RESULT_EXPIRES = 18000,
                BROKER_CONNECTION_TIMEOUT = 100,    # 30
                CELERY_SEND_EVENTS = True,
                CELERY_EVENT_QUEUE_EXPIRE = 60,
                CELERY_ALWAYS_EAGER = False,        # manage runserver
                CELERY_ACCEPT_CONTENT = ['json'],   # ['json', 'msgpack', 'yaml']
                CELERY_TASK_SERIALIZER = 'json',
                CELERY_RESULT_SERIALIZER = 'json',
                CELERY_QUEUE_SYNC_DB = "sync_migrate"
)


class syncMigration(syncMigration):
    def __init__(self, *args, **kwargs):
        super(self.__class__, self).__init__(*args, **kwargs)


# @shared_task
@app.task  #(queue='sync_migrate')
def sync_migrate():
    sync_migrate = syncMigration()
    sync_migrate.run()
