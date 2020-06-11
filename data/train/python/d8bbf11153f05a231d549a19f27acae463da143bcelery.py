'''
Created on Oct 31, 2013

@author: c3h3
'''

from __future__ import absolute_import

from celery import Celery

import os

BROKER_URL = "mongodb://localhost:27017/ptt_crawler_broker"
CELERY_MONGODB_BACKEND_HOST = os.environ.get('CELERY_MONGODB_BACKEND_HOST', 'localhost')
CELERY_MONGODB_BACKEND_PORT = int(os.environ.get('CELERY_MONGODB_BACKEND_PORT', 27017))

celery = Celery('ptt_crawler.celery',
                # broker=BROKER_URL,
                include=['ptt_crawler.tasks'])

celery.conf.update(
	BROKER_URL=BROKER_URL,
    CELERY_RESULT_BACKEND='mongodb',
    CELERY_MONGODB_BACKEND_SETTINGS={
        'host': CELERY_MONGODB_BACKEND_HOST,
        'port': CELERY_MONGODB_BACKEND_PORT,
    }
)




if __name__ == '__main__':
    celery.start()
