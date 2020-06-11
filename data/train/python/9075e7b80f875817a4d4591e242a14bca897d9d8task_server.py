#!/usr/bin/env python
# encoding: utf-8

from celery import Celery
from config.logger import Log


def make_celery(app):
    #  celery = Celery('kree', broker=app.config['CELERY_BROKER_URL'], backend=app.config['CELERY_BROKER_URL'])
    celery = Celery(app.import_name, broker=app.config['CELERY_BROKER_URL'], backend=app.config['CELERY_BROKER_URL'])
    celery.conf.update(app.config)
    TaskBase = celery.Task

    class ContextTask(TaskBase):
        abstract = True

        def __call__(self, *args, **kwargs):
            with app.app_context():
                return TaskBase.__call__(self, *args, **kwargs)

    celery.Task = ContextTask
    log = Log.getLogger(__name__)
    log.info("Task scheduling system initiald.")
    return celery
