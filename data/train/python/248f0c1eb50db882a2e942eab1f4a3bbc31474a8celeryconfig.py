from __future__ import absolute_import
import sys
from django.conf import settings

BROKER_URL = settings.REDIS_URL + '/0'
BROKER_TRANSPORT_OPTIONS = {
    'visibility_timeout': 3600,  # 1 hour.
    'fanout_prefix': True
}
CELERY_RESULT_BACKEND = settings.REDIS_URL + '/0'

CELERY_TASK_SERIALIZER = 'json'
CELERY_ACCEPT_CONTENT = ['json']
CELERY_RESULT_SERIALIZER = 'json'
CELERY_TIMEZONE = settings.TIME_ZONE
CELERY_ENABLE_UTC = True
CELERY_IGNORE_RESULT = True
CELERY_STORE_ERRORS_EVEN_IF_IGNORED = True

if 'test' in sys.argv:
    CELERY_EAGER_PROPAGATES_EXCEPTIONS = True
    CELERY_ALWAYS_EAGER = True
    BROKER_BACKEND = 'memory'
