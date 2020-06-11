# http://docs.celeryproject.org/en/v2.2.5/getting-started/first-steps-with-celery.html


# http://docs.celeryproject.org/en/v2.2.5/configuration.html#id16
BROKER_BACKEND = "redis"
BROKER_HOST = "localhost"
BROKER_PORT = 6379
BROKER_USER = "guest"
BROKER_PASSWORD = ""
BROKER_VHOST = "0"

CELERY_RESULT_BACKEND = "redis"
CELERY_REDIS_HOST = "localhost"
CELERY_REDIS_PORT = 6379
CELERY_REDIS_DB = 0

CELERY_IMPORTS = ("tasks", )

# will not be able to access results
CELERY_IGNORE_RESULT = True

CELERY_DISABLE_RATE_LIMITS = False
# CELERY_SEND_EVENTS = True
CELERY_TASK_RESULT_EXPIRES =  10

# if using django admin + sql models to maintenance schedule
#CELERYBEAT_SCHEDULER = "djcelery.schedulers.DatabaseScheduler"

