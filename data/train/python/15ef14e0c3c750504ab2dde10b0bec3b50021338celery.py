

from    kombu                           import Exchange, Queue
from    datetime                        import timedelta




BROKER_URL = 'redis://broker:6379/0'
CELERY_IMPORT = ("tasks")
BROKER_CONNECTION_TIMEOUT = 42
#BROKER_LOGIN_METHOD = "AMQPLAIN"

#: Only add pickle to this list if your broker is secured
#: from unwanted access (see userguide/security.html)
CELERY_ACCEPT_CONTENT = ['json']
CELERY_TASK_SERIALIZER = 'json'
#CELERY_RESULT_SERIALIZER = 'json'
CELERY_RESULT_PERSISTENT = False
CELERY_IGNORE_RESULT = True
CELERY_TASK_RESULT_EXPIRES = 300






# http://docs.celeryproject.org/en/latest/userguide/routing.html
CELERY_DEFAULT_QUEUE = 'default'
CELERY_DEFAULT_EXCHANGE = 'tasks'
CELERY_DEFAULT_EXCHANGE_TYPE = 'topic'






CELERYBEAT_SCHEDULE = {
    'check-every-6-hours': {
        'task': 'scanner.jobs.tasks.check_still_valid_credentials',
        'schedule': timedelta(hours=6),
        'args': ()
    }
}
