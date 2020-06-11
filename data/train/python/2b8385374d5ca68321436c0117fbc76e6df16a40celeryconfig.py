__author__ = 'sarink'

# config file for Celery Daemon

# default Redis broker
BROKER_URL = 'redis://localhost:6379/15'
#BROKER_URL = 'redis://localhost'
CELERY_RESULT_BACKEND = 'redis://localhost:6379/16'
CELERY_IGNORE_RESULT = True
#CELERY_RESULT_BACKEND = 'redis://localhost:6379/1'
BROKER_POOL_LIMIT = 100

CELERY_ACCEPT_CONTENT = ['pickle', 'json']
#CELERY_QUEUES = ['collector', 'parser', 'processor']
#CELERY_ROUTES = {"analyticsengine.collector.tasks.request_mfc": {"queue": "fetch"},
#                 ""}

from kombu import Exchange, Queue

CELERY_DEFAULT_EXCHANGE = 'collector'
CELERY_DEFAULT_EXCHANGE_TYPE = 'topic'
CELERY_DEFAULT_QUEUE = 'tasks'
CELERY_DEFAULT_ROUTING_KEY = 'tasks'
CELERY_QUEUES = (
    Queue('tasks', routing_key='tasks'),
    Queue('fetch', routing_key='fetch.#'),
    Queue('parse', routing_key='parse.#'),
    Queue('process', routing_key='process.#'),
    Queue('store', routing_key='store.#'),
)
