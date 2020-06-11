from modules.configuration import CDAS_CELERY_BACKEND
## Broker settings.

if CDAS_CELERY_BACKEND == 'amqp':
    BROKER_URL = 'amqp://guest@localhost//'

    ## Using the database to store task state and results.
    CELERY_RESULT_BACKEND = 'amqp'

elif CDAS_CELERY_BACKEND == 'redis':
    BROKER_URL = 'redis://localhost:6379/0'

    ## Using the database to store task state and results.
    CELERY_RESULT_BACKEND = 'redis://localhost:6379/0'

# List of modules to import when celery starts.
CELERY_IMPORTS = ( 'engines.celeryEngine.tasks', )

CELERYD_PREFETCH_MULTIPLIER =  4

CELERY_WORKER_DIRECT = 1

#BROKER_TRANSPORT_OPTIONS = {  'fanout_patterns': True }
#BROKER_TRANSPORT_OPTIONS = { 'fanout_prefix': True }

# CELERY_ANNOTATIONS = {'tasks.add': {'rate_limit': '10/s'}}
