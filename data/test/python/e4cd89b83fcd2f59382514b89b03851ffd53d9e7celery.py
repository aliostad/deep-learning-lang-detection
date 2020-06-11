# -*- coding: utf-8 -*-
from __future__ import absolute_import
from django.conf import settings

from celery import Celery
from kombu import Exchange, Queue

import os
import urllib


# set the default Django settings module for the 'celery' program.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'toolkit.settings')

BROKER_URL = 'sqs://{BROKER_USER}:{BROKER_PASSWORD}@sqs.us-west-1.amazonaws.com/562971026743/{CELERY_DEFAULT_QUEUE}'.format(BROKER_USER=urllib.quote(settings.AWS_ACCESS_KEY_ID, safe=''),
                                                                                                                            BROKER_PASSWORD=urllib.quote(settings.AWS_SECRET_ACCESS_KEY, safe=''),
                                                                                                                            CELERY_DEFAULT_QUEUE=settings.CELERY_DEFAULT_QUEUE)

# For custom routing
# CELERY_QUEUES = (
#     Queue('default', Exchange('default'), routing_key='default'),
# )

app = Celery('toolkit', broker=BROKER_URL,)

app.config_from_object('django.conf:settings')
app.autodiscover_tasks(lambda: settings.PROJECT_APPS)

# Optional configuration, see the application user guide.
app.conf.update(
    CELERY_TASK_RESULT_EXPIRES=3600,
)

if __name__ == '__main__':
    app.start()
