## redis related configuration, not included by default

REDIS_HOST = "localhost"
REDIS_PORT = 6379
REDIS_DB = 0

SESSION_ENGINE = 'redis_sessions.session'
SESSION_REDIS_HOST = REDIS_HOST
SESSION_REDIS_PORT = REDIS_PORT
SESSION_REDIS_DB = REDIS_DB

CELERY_RESULT_BACKEND = "redis"
CELERY_REDIS_HOST = REDIS_HOST
CELERY_REDIS_PORT = REDIS_PORT
CELERY_REDIS_DB = REDIS_DB

BROKER_TRANSPORT = "redis"
BROKER_HOST = REDIS_HOST
BROKER_PORT = REDIS_PORT
BROKER_VHOST = str(REDIS_DB)

CACHES = {
    'default': {
        'BACKEND': 'redis_cache.RedisCache',
        'LOCATION': '{host}:{port}'.format(
                host=REDIS_HOST,
                port=int(REDIS_PORT)
        ),
        'OPTIONS': {
            'DB': REDIS_DB
        }
    },
}

