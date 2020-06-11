
import logging

from datetime import timedelta

from kombu import Queue, Exchange
from celery import Celery
from celery.execute import send_task
from celery.schedules import crontab

from robotice.conf import RoboticeSettings
from conf.celery import *

LOG = logging.getLogger(__name__)

config = RoboticeSettings('reasoner')

BROKER_URL = config.broker


if "amqp" in config.broker:
    CELERY_RESULT_BACKEND = "amqp"

    default_exchange = Exchange('default')
    monitor_exchange = Exchange('monitor', type='fanout')
    reactor_exchange = Exchange('reactor', type='fanout')
    planner_exchange = Exchange('planner', type='fanout')
    control_exchange = Exchange('control', type='fanout')

    CELERY_QUEUES = (
        Queue('default', default_exchange, routing_key='default'),
        Queue('monitor', monitor_exchange, routing_key='monitor.#'),
        Queue('planner', planner_exchange, routing_key='planner.#'),
        Queue('control', control_exchange, routing_key='control.#'),
    )

elif "redis" in config.broker:
    CARROT_BACKEND = "redis"
    CELERY_RESULT_BACKEND = BROKER_URL
    # 1 hour.
    #BROKER_TRANSPORT_OPTIONS = {
    #    'visibility_timeout': 3600, 'fanout_prefix': True}
    CELERY_QUEUES = {
        "default": {"default": "default"},
        "monitor": {"monitor": "monitor.#"},
        "reactor": {"reactor": "reactor.#"},
        "planner": {"planner": "planner.#"},
    }

CELERY_IMPORTS = (
    "reasoner.tasks", "monitor.tasks", "reactor.tasks", "planner.tasks")


CELERY_ROUTES = {
    'monitor.get_real_data': {
        'queue': 'monitor',
    },
    'planner.get_model_data': {
        'queue': 'planner',
    },
    'reasoner.compare_data': {
        'queue': 'reasoner',
    },
    'reasoner.process_real_data': {
        'queue': 'reasoner',
    },
    'reactor.commit_action': {
        'queue': 'reactor',
    }
}


CELERYBEAT_SCHEDULE = {
    'compare-data': {
        'task': 'reasoner.compare_data',
        'schedule': timedelta(seconds=60),
        'args': (config, ),
    },
    'real-data-reader': {
        'task': 'monitor.get_real_data',
        'schedule': timedelta(seconds=60),
        'args': (config, ),
    },
    'planned-data-reader': {
        'task': 'planner.get_model_data',
        'schedule': timedelta(seconds=60),
        'args': (config, ),
    },
}

celery = Celery('robotice', broker=BROKER_URL)
