import os
from kombu import Queue, Exchange

## Broker settings.
BROKER_URL = os.getenv('BROKER_URL', 'amqp://guest:guest@localhost:5672')
#BROKER_URL = "amqp://guest:guest@localhost:5672/"
#BROKER_URL = os.getenv('BROKER_URL', 'redis://guest@localhost:6379')

#BROKER_HOST = "localhost"
#BROKER_PORT = 27017
#BROKER_TRANSPORT = 'mongodb'
#BROKER_VHOST = 'celery'

CELERY_DEFAULT_QUEUE = 'default'

CELERY_QUEUES = (
    Queue('default', exchange=Exchange('default'),   routing_key='default'),
#    Queue('aws_uploads', routing_key='video.uploads'),
)

CELERY_DEFAULT_EXCHANGE = 'default'
CELERY_DEFAULT_EXCHANGE_TYPE = 'direct'
CELERY_DEFAULT_ROUTING_KEY = 'default'

CELERY_IMPORTS = ('celeryservice.tasks',)
#CELERY_RESULT_BACKEND = os.getenv('CELERY_RESULT_BACKEND', 'redis')
CELERY_RESULT_BACKEND = os.getenv('CELERY_RESULT_BACKEND', 'amqp')
## Using the database to store task state and results.
#CELERY_RESULT_BACKEND = "mongodb"
#CELERY_MONGODB_BACKEND_SETTINGS = {
#    "host": "localhost",
#    "port": 27017,
#    "database": "celery",
#    "taskmeta_collection": "celery_taskmeta",
#}
