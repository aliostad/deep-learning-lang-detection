# -*- coding: utf-8 -*-
#
# local celery settings - extending the settings.py
#

from .settings import *

try:

    BROKER_HOST = "localhost"
    BROKER_PORT = 5672
    BROKER_USER = "spike"
    BROKER_PASSWORD = "spike"
    BROKER_VHOST = "spike"
    CELERY_BACKEND = "amqp"
    CELERY_RESULT_DBURI = ""
    CELERY_TASK_RESULT_EXPIRES = 18000 # 5 hours

    CELERYBEAT_SCHEDULER = 'djcelery.schedulers.DatabaseScheduler'

    CELERY_SEND_TASK_ERROR_EMAILS = True
    CELERYD_MAX_TASKS_PER_CHILD = 50 # as long as memleaking is still an issue

    USE_CELERY = True

except ImportError:

    USE_CELERY = False

# override celery usage
USE_CELERY_OVERRIDE = None
