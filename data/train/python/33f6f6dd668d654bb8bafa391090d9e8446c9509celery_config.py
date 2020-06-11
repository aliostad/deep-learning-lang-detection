import urllib
# Amazon SQS parameters
BROKER_TRANSPORT = 'sqs'
BROKER_TRANSPORT_OPTIONS = {'queue_name_prefix': 'celery-',
                            'visibility_timeout': 3600,
                            'region': 'us-west-2',
                            'polling_interval': 1}

# these should be url encode for broker to work properly
BROKER_USER = urllib.quote('AKIAJZCVQZVAUMMYZNPA', safe='')
BROKER_PASSWORD = urllib.quote('o6YVORM2g1Rv2NZRnQoSKoxX4OfxnTimKL340oLl', safe='')

CELERY_BROKER_URL = 'sqs://%s:%s@' % (BROKER_USER, BROKER_PASSWORD)

#CELERY_BROKER_URL = 'redis://localhost:6379/0'
CELERY_RESULTS_URL = 'redis://localhost:6379/1'

BROKER_POOL_LIMIT = 10
BROKER_CONNECTION_TIMEOUT = 4
BROKER_CONNECTION_MAX_RETRIES = 100

CELERY_TASK_RESULT_EXPIRES=3600
#CELERY_TASK_SERIALIZER='json',
#CELERY_ACCEPT_CONTENT=['json'],
#CELERY_RESULT_SERIALIZER='json',

#CELERY_TIMEZONE='Europe/Oslo',
CELERY_ENABLE_UTC=True

#CELERY_ANNOTATIONS = {'tasks.add': {'rate_limit': '10/s'}}
#CELERY_ROUTES = {'tasks.add': 'low-priority',}