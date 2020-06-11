import pymysql
from celery import Celery
from app import app, mail

app.config.update(
    CELERY_BROKER_URL='redis://localhost:6379/0',
)


def make_celery(app):
    celery = Celery(app.import_name, broker=app.config['CELERY_BROKER_URL'])
    celery.conf.update(app.config)
    TaskBase = celery.Task
    class ContextTask(TaskBase):
        abstract = True
        def __call__(self, *args, **kwargs):
            with app.app_context():
                return TaskBase.__call__(self, *args, **kwargs)
    celery.Task = ContextTask
    return celery

pymysql.install_as_MySQLdb()
celery = make_celery(app)