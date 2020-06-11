from datetime import timedelta

BROKER_HOST = "localhost"
BROKER_PORT = 5672
BROKER_USER = "myuser"
BROKER_PASSWORD = "mypassword"
BROKER_VHOST = "myvhost"
CELERY_RESULT_BACKEND = "amqp"
CELERY_AMQP_TASK_RESULT_EXPIRES = 300
CELERY_IMPORTS = ("testapp.tasks", )
CELERY_ROUTES = ("testapp.process_router.ProcessRouter",)
CELERYBEAT_SCHEDULER = "testapp.ntimes_scheduler.NTimesScheduler"
CELERYBEAT_SCHEDULE = {
    "runs-right-away": {
        "task": "testapp.tasks.add",
        "schedule": timedelta(seconds=0),
        "times": 1,
        "args": (16, 16)
    },
    "runs-every-five": {
        "task": "testapp.tasks.add",
        "schedule": timedelta(seconds=15),
        "args": (5, 10)
    },
}
