import djcelery
djcelery.setup_loader()

CELERY_REDIS = True

if CELERY_REDIS:
    # Celery with Redis back-end
    BROKER_BACKEND = "redis"
    BROKER_HOST = "localhost"  # Maps to redis host.
    BROKER_PORT = 6379         # Maps to redis port.
    BROKER_VHOST = "1"         # Maps to database number.

    CELERY_RESULT_BACKEND = "redis"
    REDIS_HOST = "localhost"
    REDIS_PORT = 6379
    REDIS_DB = 1 
else:
    # AMQP config
    BROKER_HOST = "192.168.1.77"
    BROKER_PORT = 5672
    BROKER_USER = "celery"
    BROKER_PASSWORD = "celery"
    BROKER_VHOST = "celery_vhost"
    CELERY_RESULT_BACKEND = "amqp"

CELERY_QUEUES = {
    "redflash" : {
                "exchange" : "redflash",
                "binding_key" : "redflash",
                }
}
CELERY_DEFAULT_QUEUE = "redflash"

# set True if you don't want to consume results
CELERY_IGNORE_RESULT = True
CELERY_DISABLE_RATE_LIMITS = True
