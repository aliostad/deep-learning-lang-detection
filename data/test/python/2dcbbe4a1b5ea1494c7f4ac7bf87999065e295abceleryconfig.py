__author__ = 'rizki'

import os
from kombu import Queue


## Broker settings.
BROKER_URL = os.getenv('BROKER_URL', 'amqp://guest:guest@localhost:5672')

BROKER_HEARTBEAT=0
#BROKER_HOST = "localhost"
#BROKER_PORT = 27017
#BROKER_TRANSPORT = 'mongodb'
#BROKER_VHOST = 'celery'

BROKER_POOL_LIMIT = 500

CELERY_ACKS_LATE = False
CELERY_DISABLE_RATE_LIMITS = True
CELERY_EVENT_SERIALIZER = 'json'
CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'
#CELERY_EVENT_SERIALIZER = 'msgpack'
#CELERY_TASK_SERIALIZER = 'msgpack'
#CELERY_RESULT_SERIALIZER = 'json'
#CELERY_EVENT_SERIALIZER = 'pickle'
#CELERY_TASK_SERIALIZER = 'pickle'
#CELERY_RESULT_SERIALIZER = 'pickle'
CELERY_ACCEPT_CONTENT = ['json', 'msgpack', 'pickle']
CELERY_DEFAULT_QUEUE = 'payment_default1'
CELERY_QUEUES = (
    Queue('default', routing_key='default'),
    Queue('payment_default1', routing_key='payment.tasks1'),
    Queue('payment_default2', routing_key='payment.tasks1'),
)
CELERY_DEFAULT_EXCHANGE = 'payment.tasks1'
CELERY_DEFAULT_EXCHANGE_TYPE = 'direct'
CELERY_DEFAULT_ROUTING_KEY = 'payment.tasks1'

#CELERY_IMPORTS = ('backend.v1', 'tornadoist.tcelerymixin',)
CELERY_IMPORTS = ('backend.v1',)
CELERY_RESULT_BACKEND = os.getenv('CELERY_RESULT_BACKEND', 'amqp')
#CELERY_IGNORE_RESULT = True  # useful for fire and forget mode

CELERYD_PREFETCH_MULTIPLIER = 0
CELERYD_MAX_TASKS_PER_CHILD = 100
