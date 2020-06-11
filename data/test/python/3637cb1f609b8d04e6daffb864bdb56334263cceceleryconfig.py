import os
from kombu import Exchange, Queue
from .routers import PrefixRouter

MILERY_OUTPUT = os.environ.get('MILERY_OUTPUT')
MILERY_NODE_NAME = os.environ.get('MILERY_NODE_NAME', 'default')
MILERY_BROKER = os.environ.get('MILERY_BROKER', '')

BROKER_URL = 'amqp://tonyg:changeit@{}'.format(MILERY_BROKER)
CELERY_RESULT_BACKEND = BROKER_URL

CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'
CELERY_ACCEPT_CONTENT=['json']

CELERY_CREATE_MISSING_QUEUES = False
CELERY_DEFAULT_QUEUE = 'milery'
CELERY_DEFAULT_ROUTING_KEY = ''
CELERY_QUEUES = (Queue('milery', Exchange('milery', type='direct')),)
CELERY_ROUTES = (PrefixRouter('milery.outbox', 'milery.tasks.p'),)

CELERY_IGNORE_RESULT = True
