from kombu import Exchange, Queue

#BROKER_HOST = "localhost"
#BROKER_PORT = 5672
#BROKER_USER = "will"
#BROKER_PASSWORD = "dampier"
#BROKER_VHOST = "pythontasks"

BROKER_URL = 'amqp://will:dampier@localhost:5672/'
CELERY_RESULT_BACKEND = 'amqp://'

CELERY_TASK_SERIALIZER = 'pickle'
CELERY_RESULT_SERIALIZER = 'pickle'


CELERY_IMPORTS = ('HIVTransTool',
                  'TreeingTools',
                  'HIVSeqDBManagement')

CELERY_MAX_CACHED_RESULTS = 100000
CELERY_TRACK_STARTED = True
CELERYD_MAX_TASKS_PER_CHILD = 10
CELERYD_POOL_RESTARTS = True
CELERY_SEND_EVENTS = True
CELERYD_HIJACK_ROOT_LOGGER = False
CELERYD_PREFETCH_MULTIPLIER = 1
CELERY_ACKS_LATE = True

CELERY_QUEUES = [Queue('HIVTransTool'),
                 Queue('celery'),
                 Queue('long-running'),
                 Queue('base'),
                 Queue('HIVSeqDBManagement'),
                 Queue('writingqueue'),
                 ]


CELERY_ANNOTATIONS = {
    'HIVSeqDBManagement.query_LANL': {'rate_limit': '10/m'},
    'TreeingTools.write_results_to_mongo': {'rate_limit': '10/s'},
    'TreeingTools.process_region': {'rate_limit': '10/m'}
}

CELERY_ROUTES = {
    'TreeingTools.write_results_to_mongo': {'queue': 'writingqueue'}
}
