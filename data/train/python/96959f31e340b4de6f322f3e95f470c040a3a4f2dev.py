from __init__ import *

DEBUG = True
TEMPLATE_DEBUG = DEBUG

DBINFO = {
    'ENGINE': 'django.db.backends.postgresql_psycopg2',
    'NAME': 'tkz',
    'USER': 'tkz',
}

for item in ('default', 'read'):
    DATABASES[item].update(DBINFO)

EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_HOST_USER = 'dev@tokeniz.com'
EMAIL_HOST_PASSWORD = ''
EMAIL_USE_TLS = True
DEFAULT_FROM_EMAIL = 'dev@tokeniz.com'

ADMIN_MEDIA_PREFIX = '/media/admin-media/'

### RABBITMQ CONFIG {{{1
BROKER_TRANSPORT = 'amqp'
BROKER_USER = 'guest'
BROKER_PASSWORD = ''
BROKER_HOST = 'localhost'
BROKER_PORT = 5672
BROKER_VHOST = '/'

# Assemble into Celery's BROKER_URL
BROKER_URL = '{0}://{1}:{2}@{3}:{4}{5}'.format(
    BROKER_TRANSPORT,
    BROKER_USER,
    BROKER_PASSWORD,
    BROKER_HOST,
    BROKER_PORT,
    BROKER_VHOST
)

try:
    from dev_local import *
except ImportError:
    pass
