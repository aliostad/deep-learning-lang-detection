#encoding=utf-8
from __future__ import absolute_import

import os
from kombu import Exchange, Queue
from celery import Celery
from django.conf import settings

BASE_DIR = os.path.dirname(__file__)

project_name = BASE_DIR.split(os.sep)[-1:][0]

os.environ.setdefault('DJANGO_SETTINGS_MODULE', project_name + '.settings')

broker = getattr(settings, 'CELERY_BROKER', '')
app = Celery(project_name, broker=broker)

app.config_from_object('django.conf:settings')
app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)
app.conf.update(
    CELERY_RESULT_BACKEND='djcelery.backends.database:DatabaseBackend',
    CELERYBEAT_SCHEDULER='djcelery.schedulers.DatabaseScheduler',
    CELERY_DEFAULT_QUEUE=project_name,
    CELERY_QUEUES=(
        Queue(project_name, Exchange(project_name), routing_key=project_name),
    )
)
