# -*- coding: utf-8 -*-

__author__ = 'Sergey Sobko'

from eve import Eve
from celery import Celery

from cheque.settings import (
    CELERY_BROKER_URL,
    CELERY_RESULT_BACKEND,
    EVE_SETTINGS,
    SECRET_KEY
)


app = Eve(settings=EVE_SETTINGS)

app.config['DEBUG'] = True

app.config['CELERY_BROKER_URL'] = CELERY_BROKER_URL
app.config['CELERY_RESULT_BACKEND'] = CELERY_RESULT_BACKEND

app.config['SECRET_KEY'] = SECRET_KEY

celery = Celery(app.name, broker=app.config['CELERY_BROKER_URL'])
celery.conf.update(app.config)
