# List of modules to import when celery starts.
CELERY_IMPORTS = ("lifescore.tasks", )

## Result store settings.
CELERY_RESULT_BACKEND = "cache"
CELERY_CACHE_BACKEND = 'memcached://127.0.0.1:11211/'

## Broker settings.
BROKER_HOST = "localhost"
BROKER_PORT = 5672
BROKER_VHOST = "/"
BROKER_USER = "guest"
BROKER_PASSWORD = "guest"

## Worker settings
## If you're doing mostly I/O you can have more processes,
## but if mostly spending CPU, try to keep it close to the
## number of CPUs on your machine. If not set, the number of CPUs/cores
## available will be used.
CELERYD_CONCURRENCY = 10
# CELERYD_LOG_FILE = "celeryd.log"
# CELERYD_LOG_LEVEL = "INFO"

# Custom Settings for App
CELERY_RESULT_DBURI = "mysql+mysqldb://lifescore:5mad_cows@localhost/lifescore?charset=utf8&use_unicode=0"
