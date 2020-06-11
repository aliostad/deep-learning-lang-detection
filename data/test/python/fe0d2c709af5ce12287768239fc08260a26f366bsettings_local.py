#Project settings for local development. These settings will override those production settings used by default
INSTANCE = 'LOCAL'

DEBUG = True
TEMPLATE_DEBUG = DEBUG
CELERY_ALWAYS_EAGER = True
#BROKER_BACKEND = 'memory'

FACEBOOK_APP_ID = "109670439189264"
FACEBOOK_APP_SECRET = "c13e178c21c89043dcd4b0ac53725d6b"

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
        'LOCATION': 'unique-snowflake'
    }
}

BROKER_BACKEND = "mongodb"
BROKER_HOST = "localhost"
BROKER_PORT = 27017
BROKER_USER = "keenuser"
BROKER_PASSWORD = "trolley@57"
BROKER_VHOST = "celery"