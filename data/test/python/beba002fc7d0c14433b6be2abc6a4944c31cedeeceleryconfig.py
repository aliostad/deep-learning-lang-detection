from kombu import Exchange, Queue

""" AMQP as Broker """
BROKER_URL = 'amqp://guest:guest@localhost:5672//'
BROKER_CONNECTION_TIMEOUT = 4  # Default Value
BROKER_CONNECTION_RETRY = True
BROKER_CONNECTION_MAX_RETRIES = 100	# Default Value

""" Broker Heartbeat Settings => Time(sec.) = Broker_Heartbeat(sec.)/Rate """
# Time in Seconds
BROKER_HEARTBEAT = 4
# Rate
BROKER_HEARTBEAT_CHECKRATE = 2

""" REDIS as backend to store task state and results """
CELERY_RESULT_BACKEND = 'redis://localhost/0'
CELERY_RESULT_EXCHANGE = 'thugresults'
CELERY_RESULT_EXCHANGE_TYPE = 'direct'

""" Msg will not be lost if broker restarts/shutdown """
CELERY_RESULT_PERSISTENT = True

""" Time after which task results would delete """
# Never Expires(eg. 24*3600->1 day)
CELERY_TASK_RESULT_EXPIRES = None		

""" Default Queue Configuration """
CELERY_DEFAULT_QUEUE = 'generic'
CELERY_DEFAULT_EXCHANGE = 'generic'
CELERY_DEFAULT_EXCHANGE_TYPE = 'direct'
CELERY_DEFAULT_BINDING = 'generic'
CELERY_DEFAULT_ROUTING_KEY = 'generic'
CELERY_DEFAULT_DELIVERY_MODE = 'persistent'

""" ACKS_LATE means that tasks msgs will be acknowledged after task has been
    executed and then only it will be deleted from queue.
"""
CELERY_ACKS_LATE = True

""" Giving each worker only TWO task at a time """
CELERYD_PREFETCH_MULTIPLIER = 2

""" Concurrency Settings """
# No. of Concurrent worker processes/threads executing tasks
CELERYD_CONCURRENCY = 4

""" Message Settings """
CELERY_MESSAGE_COMPRESSION = None

""" Tasks Settings """
# Task reports its status as "started" when task is executed on worker
CELERY_TRACK_STARTED = True
CELERY_TASK_PUBLISH_RETRY = True
