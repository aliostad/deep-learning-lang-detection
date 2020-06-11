__author__ = 'Marc'

import os
import logging
import time

from celery import Celery

CLOUDAMQP_URL = os.environ.get('CLOUDAMQP_URL')
if CLOUDAMQP_URL is not None:
    CLOUDAMQP_URL += '?heartbeat=30'
else:
    CLOUDAMQP_URL = 'amqp://'

celery = Celery('celery_inst',
                #backend='amqp',
                broker=CLOUDAMQP_URL,
                include=['tasks'])

celery.BROKER_POOL_LIMIT = 1
celery.BROKER_CONNECTION_TIMEOUT = 10

# Optional configuration, see the application user guide.
celery.conf.update(
    BROKER_URL=os.environ.get('MONGOHQ_URL', "mongodb://localhost:27017/omicsservices"),
    CELERY_TASK_RESULT_EXPIRES=3600,
    CELERY_RESULT_BACKEND='amqp',
    CELERY_IGNORE_RESULT=False,
    BROKER_POOL_LIMIT=1,
    BROKER_CONNECTION_TIMEOUT=10
)

if __name__ == '__main__':
    celery.start()