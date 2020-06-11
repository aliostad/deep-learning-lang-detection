# List of modules to import when celery starts.
# CELERY_IMPORTS = ('libcloud_sandbox.tasks.code_execute', )

# Result store settings.
CELERY_RESULT_BACKEND = 'database'
CELERY_RESULT_DBURI = 'sqlite:///mydatabase.db'

# Broker settings.
BROKER_TRANSPORT = 'sqlalchemy'
BROKER_HOST = 'sqlite:///tasks.db'
BROKER_PORT = 5672
BROKER_VHOST = '/'
BROKER_USER = 'guest'
BROKER_PASSWORD = 'guest'

## Worker settings
CELERYD_CONCURRENCY = 1
CELERYD_TASK_TIME_LIMIT = 20
# CELERYD_LOG_FILE = 'celeryd.log'
CELERYD_LOG_LEVEL = 'INFO'