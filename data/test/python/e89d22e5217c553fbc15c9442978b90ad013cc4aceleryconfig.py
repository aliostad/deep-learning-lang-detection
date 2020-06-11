# Default configuration for Celery; can be overridden with an
# xtas_celeryconfig module in the PYTHONPATH.

import os
from kombu import Exchange, Queue

_BROKER_HOST=os.environ.get('NLPIPE_BROKER_HOST', '127.0.0.1')
_BROKER_USERNAME=os.environ.get('NLPIPE_BROKER_USERNAME', 'guest')
_BROKER_PASSWORD=os.environ.get('NLPIPE_BROKER_PASSWORD', 'guest')
_BROKER_PORT=int(os.environ.get('NLPIPE_BROKER_PORT', 5672))

BROKER_URL = 'amqp://{user}:{passwd}@{host}:{port}//'.format(
    user=_BROKER_USERNAME, passwd=_BROKER_PASSWORD, host=_BROKER_HOST, port=_BROKER_PORT)
CELERY_RESULT_BACKEND = 'rpc'

CELERY_QNAME = os.environ.get('NLPIPE_CELERY_QUEUE', 'nlpipe')
CELERY_DEFAULT_QUEUE = CELERY_QNAME
CELERY_DEFAULT_EXCHANGE_TYPE = 'direct'

CELERY_QUEUES = (
    Queue(CELERY_QNAME, Exchange('default'), routing_key=CELERY_QNAME),
    Queue('background', durable=False, routing_key='background'),
)

CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'
CELERY_ACCEPT_CONTENT=['json']
CELERY_TIMEZONE = 'Europe/Amsterdam'
CELERY_ENABLE_UTC = True

CELERY_TASK_RESULT_EXPIRES = 3600

# Uncomment the following to make Celery tasks run locally (for debugging).
CELERY_ALWAYS_EAGER = os.environ.get('NLPIPE_EAGER', 'N').upper().startswith('Y')

CELERY_DISABLE_RATE_LIMITS = True
