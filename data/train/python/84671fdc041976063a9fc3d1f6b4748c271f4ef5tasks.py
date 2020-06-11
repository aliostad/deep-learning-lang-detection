from celery import Celery
from crawler_worker import CrawlerWorker

BROKER_URL = 'mongodb://localhost:27017/realto'

celery = Celery('tasks', broker=BROKER_URL)

celery.conf.update(
    CELERY_RESULT_BACKEND='mongodb://localhost:27017',
    CELERY_MONGODB_BACKEND_SETTINGS={
        'database': 'realto',
        'taskmeta_collection': 'realto_taskmetacollection'
    },
    CELERY_TASK_SERIALIZER='json',
    CELERY_RESULT_SERIALIZER='json',
    CELERY_ACCEPT_CONTENT=['json']
)


@celery.task
def process_new_config(config):
    wokrer = CrawlerWorker()
    wokrer.run(config)
