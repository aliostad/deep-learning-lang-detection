# Tasks

CELERY_IMPORTS = (
    'ubuild.worker.tasks',
)

# Worker

CELERYD_PREFETCH_MULTIPLIER = 1

CELERYD_LOG_COLOR = False

# Results

CELERY_RESULT_BACKEND = 'redis'

REDIS_HOST = 'localhost'
REDIS_PORT = 6379
REDIS_PASSWORD = 'password'
REDIS_RECONNECT_RETRY = True

# Messages

BROKER_HOST = 'localhost'
BROKER_USER = 'guest'
BROKER_PASSWORD = 'guest'

CELERY_TRACK_STARTED = True
CELERY_DISABLE_RATE_LIMITS = True
CELERY_ACKS_LATE = True

# Admin

CELERY_SEND_TASK_ERROR_EMAILS = True
ADMINS = (
    ('Mikhail Gusarov', 'dottedmag@dottedmag.net'),
)

