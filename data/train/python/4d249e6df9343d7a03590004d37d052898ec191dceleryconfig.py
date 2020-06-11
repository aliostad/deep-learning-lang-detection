### RABBITMQ ###
BROKER_HOST = "localhost"
BROKER_PORT = 5672
BROKER_USER = "rainq"
BROKER_PASSWORD = ""
BROKER_VHOST = "/"

CELERY_RESULT_BACKEND = "amqp"
CELERY_IMPORTS = ("rainq.tasks", )
CELERY_DISABLE_RATE_LIMITS = True
CELERY_DEFAULT_QUEUE = "rainq_worker"
CELERY_DEFAULT_EXCHANGE_TYPE = "direct"
CELERY_DEFAULT_ROUTING_KEY = "rainq_worker"
CELERY_QUEUES = {
    CELERY_DEFAULT_QUEUE: {
        "exchange": CELERY_DEFAULT_QUEUE,
        "binding_key": CELERY_DEFAULT_ROUTING_KEY,
    },
    "rainq_app": {
        "exchange": "rainq_app",
        "binding_key": "rainq.app",
    },
}
# 'process_result' is a wrap-up task that MUST execute on the appserver
CELERY_ROUTES = (
    {"rainq.tasks.process_result":
        {
            "queue": "rainq_app",
            "routing_key": "rainq.app",
        }
    },
)
