#!/usr/bin/env python
# coding:utf-8

"""
run as celery worker:
celery -A celery_tasks worker --loglevel=info
"""
"""
run celery flower(a web based tool for monitoring and administrating Celery clusters):
celery -A celery_tasks flower --port=5555 --broker=amqp://celery_user:celery_password@192.168.100.100:5672/celery_vhost

run celery events(a command line tool for monitoring and administrating Celery clusters):
celery -A celery_tasks events
"""

import datetime
import time
import random

from celery import Celery

# [1] RabbitMQ as broker
BROKER_URL = 'amqp://celery_user:celery_password@192.168.100.100:5672/celery_vhost'

# [2] redis as broker
# BROKER_URL = 'redis://192.168.100.100:6379/0'

# result_backend
CELERY_RESULT_BACKEND = 'redis://192.168.100.100:6379/1'

celery_app = Celery(
    main='celery_tasks',
    broker=BROKER_URL,
    backend=CELERY_RESULT_BACKEND,
)

@celery_app.task
def func(n=0):
    start = datetime.datetime.now().strftime('%y-%m-%d %H:%M:%S')
    time.sleep(n)
    stop = datetime.datetime.now().strftime('%y-%m-%d %H:%M:%S')
    return '[%s] (%s) [%s]' % (start, n, stop)
