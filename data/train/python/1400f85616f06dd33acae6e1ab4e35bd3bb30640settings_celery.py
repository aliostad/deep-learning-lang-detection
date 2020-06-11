
try:
    import djcelery
    djcelery.setup_loader()
except:
    pass

BROKER_HOST = "127.0.0.1"
BROKER_PORT = 5672
BROKER_VHOST = "{{domain}}"
BROKER_USER = "{{broker_user}}"
BROKER_PASSWORD = "{{broker_pass}}"

CELERY_DEFAULT_QUEUE = '{{celery_queue|default(user)}}'
CELERY_SEND_TASK_ERROR_EMAILS = True

CELERY_TASK_PUBLISH_RETRY = {"max_retries": 3,
                            "interval_start": 0,
                            "interval_step": 0.2,
                            "interval_max": 0.2}

CELERY_ALWAYS_EAGER = True

CELERYD_CONCURRENCY = {{celery_worker_count|default(1)}}
