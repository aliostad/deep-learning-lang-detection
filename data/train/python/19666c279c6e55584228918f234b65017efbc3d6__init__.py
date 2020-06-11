from __future__ import absolute_import
from celery import Celery
import os

INCLUDES = (
    "kwcontributes.github_archive"
)

DEFAULT_URL = "amqp://guest:guest@localhost:5672"

app = Celery('kwcontributes',
             backend='amqp',
             broker=os.environ['BROKER_URL'] if "BROKER_URL" in os.environ.keys() else DEFAULT_URL,
             include=INCLUDES
)

app.conf.update(
    CELERY_TASK_SERIALIZER = 'json',
    CELERY_ACCEPT_CONTENT = ('json',),
    CELERY_RESULT_SERIALIZER = 'json',
    CELERY_ACKS_LATE = True,
    CELERYD_PREFETCH_MULTIPLIER = 1
)

if __name__ == '__main__':
    app.start()
