
DATABASES = {
    'default': {
        'ENGINE': 'postgresql_psycopg2',
        'NAME': 'quakes',
        'USER': '',
        'PASSWORD': '',
        'HOST': '',
        'PORT': '',
    }
}
SECRET_KEY = 'm8+6(#w=tod@3hmlvs6q*_t2pu+v&_zctb1*rw@-86r+1_(2(r'

INSTALLED_APPS = (
    'django.contrib.gis',
    'quakes',
    'djcelery',
)

import djcelery
djcelery.setup_loader()
CELERY_RESULT_BACKEND = "redis"
CELERY_REDIS_HOST = "localhost"
CELERY_REDIS_PORT = 6379
CELERY_REDIS_DB = 0
BROKER_BACKEND = 'redis'
BROKER_HOST = "localhost"
BROKER_PORT = 6379
BROKER_USER = ""
BROKER_PASSWORD = ""

try:
    from local_settings import *
except ImportError:
    pass
