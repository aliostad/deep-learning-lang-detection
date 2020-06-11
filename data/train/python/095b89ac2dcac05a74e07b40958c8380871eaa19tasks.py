from celery import Celery
import iron_celery
import time
import os

celery = Celery('tasks')
celery.conf.update(
    #BROKER_URL='ironmq://<project_id>:<token>@',
    BROKER_URL=os.environ.get('CELERY_BROKER', None),
    #BROKER_URL='redis://localhost:6379/0',
    BROKER_POOL_LIMIT=2,
    CELERY_TASK_SERIALIZER='json',
    CELERY_RESULT_SERIALIZER='json',
    CELERY_ACCEPT_CONTENT = ['json'],
    #CELERY_RESULT_BACKEND='redis://localhost:6379/0',
    CELERY_RESULT_BACKEND=os.environ.get('CELERY_BACKEND', None),
    # CELERY_MONGODB_BACKEND_SETTINGS = {
    #   'database': 'nugqueue',
    #   'taskmeta_collection': 'tasks',
    # }
)

@celery.task
def add(x, y):
    print('Celery task {0}, {1}'.format(x, y))
    time.sleep(1)
    return x + y
