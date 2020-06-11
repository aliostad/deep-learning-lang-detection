# encoding: utf-8
from settings import *
from bundle_config import config

DEBUG = False
TEMPLATE_DEBUG = DEBUG

EMAIL_BACKEND = 'django_ses.SESBackend'

SITE_ID = 1

MEDIA_ROOT = os.path.join(os.getenv('EPIO_DATA_DIRECTORY'), 'media')

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql_psycopg2",
        "HOST": config['postgres']['host'],
        "PORT": int(config['postgres']['port']),
        "USER": config['postgres']['username'],
        "PASSWORD": config['postgres']['password'],
        "NAME": config['postgres']['database'],
    },
}

CELERY_ALWAYS_EAGER = False
CELERY_RESULT_BACKEND = "redis"
CELERY_REDIS_DB = 0
REDIS_HOST = CELERY_REDIS_HOST = config['redis']['host']
REDIS_PORT = CELERY_REDIS_PORT = int(config['redis']['port'])
REDIS_PASSWORD = CELERY_REDIS_PASSWORD = config['redis']['password']
REDIS_CONNECT_RETRY = True

BROKER_BACKEND = "redis"
BROKER_TRANSPORT = "redis"
BROKER_HOST = config['redis']['host']
BROKER_PORT = int(config['redis']['port'])
BROKER_PASSWORD = config['redis']['password']
BROKER_VHOST = 0
