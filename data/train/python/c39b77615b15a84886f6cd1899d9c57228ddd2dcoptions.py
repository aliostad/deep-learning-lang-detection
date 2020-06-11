"""Mapping of recipe options to celery configuration directives.
"""

STRING_OPTIONS = {
    'broker-url' : 'BROKER_URL',
    'broker-password': 'BROKER_PASSWORD',
    'broker-transport': 'BROKER_TRANSPORT',
    'broker-user': 'BROKER_USER',
    'broker-vhost': 'BROKER_VHOST',
    'celeryd-log-file': 'CELERYD_LOG_FILE',
    'celeryd-log-level': 'CELERYD_LOG_LEVEL',
    'result-backend': 'CELERY_RESULT_BACKEND',
    'result-dburi': 'CELERY_RESULT_DBURI',
    'broker-host': 'BROKER_HOST',
}

NUMERIC_OPTIONS = {
    'broker-port': 'BROKER_PORT',
    'celeryd-concurrency': 'CELERYD_CONCURRENCY',
}

SEQUENCE_OPTIONS = {
    'imports': 'CELERY_IMPORTS',
}
