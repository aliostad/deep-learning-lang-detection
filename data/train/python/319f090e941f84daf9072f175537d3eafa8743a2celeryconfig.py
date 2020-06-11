#BROKER_URL = 'amqp://guest:guest@localhost:5672//'

#CELERY_ALWAYS_EAGER = True



CELERY_RESULT_BACKEND = 'amqp'
CELERY_RESULT_PERSISTENT = True
CELERY_TASK_RESULT_EXPIRES = None

CELERY_DEFAULT_QUEUE = 'default'
CELERY_QUEUES = {
    'default': {
        'binding_key': 'task.#',
        },
    'submitt_to_utl': {
        'binding_key': 'submitt_to_utl.#',
        }
    }
CELERY_DEFAULT_EXCHANGE = 'tasks'
CELERY_DEFAULT_EXCHANGE_TYPE = 'topic'
CELERY_DEFAULT_ROUTING_KEY = 'task.default'
#CELERYBEAT_SCHEDULER = "djcelery.schedulers.DatabaseScheduler"


BROKER_HOST = "127.0.0.1"
BROKER_PORT = 5672
BROKER_USER = "mobilevrs"
BROKER_PASSWORD = "mobilevrs"
BROKER_VHOST = "mobilevrs"

AMQP_SERVER = "127.0.0.1"
AMQP_PORT = 5672
AMQP_USER = "mobilevrs"
AMQP_PASSWORD = "mobilevrs"
AMQP_VHOST = "mobilevrs"




CELERY_ROUTES = {
    'mobilevrs.tasks.submitt_to_utl': {
        'queue': 'submitt_to_utl',
        'routing_key': 'submitt_to_utl.result'
    },


    }

CELERY_TIMEZONE = 'Africa/Kampala'
