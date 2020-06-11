# -*- coding: utf-8 -*-
"""
Django settings for django_celery_demo project.

For more information on this file, see
https://docs.djangoproject.com/en/1.6/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.6/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
import os
import json
BASE_DIR = os.path.dirname(os.path.dirname(__file__))

with open(os.path.join(BASE_DIR, 'envs/dev.json')) as env_file:
    ENV_TOKENS = json.load(env_file)

with open(os.path.join(BASE_DIR, 'envs/auth.json')) as env_file:
    AUTH_TOKENS = json.load(env_file)

# 使用缓存而不是mysql存celery任务
# See https://docs.djangoproject.com/en/dev/topics/cache/
CACHES = ENV_TOKENS['CACHES']

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.6/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'a396x-fo*1oo_ex@6#jnm#j7a_ub$@w+fqb6ii=e^f562#7a&)'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

TEMPLATE_DEBUG = True

ALLOWED_HOSTS = []


# Application definition

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'djcelery',
    'tester_app',
)

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
)

ROOT_URLCONF = 'django_celery_demo.urls'

WSGI_APPLICATION = 'django_celery_demo.wsgi.application'


# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}

# Internationalization
# https://docs.djangoproject.com/en/1.6/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.6/howto/static-files/

STATIC_URL = '/static/'

################## celery ##################
import djcelery
djcelery.setup_loader()
CELERYBEAT_SCHEDULER = 'djcelery.schedulers.DatabaseScheduler'
# 这部分配置来自edx

# Don't use a connection pool, since connections are dropped by ELB.
BROKER_POOL_LIMIT = 0
BROKER_CONNECTION_TIMEOUT = 1

# For the Result Store, use the django cache named 'celery'
CELERY_RESULT_BACKEND = 'cache'
CELERY_CACHE_BACKEND = 'celery'

# When the broker is behind an ELB, use a heartbeat to refresh the
# connection and to detect if it has been dropped.
BROKER_HEARTBEAT = 10.0
BROKER_HEARTBEAT_CHECKRATE = 2

# Each worker should only fetch one message at a time
CELERYD_PREFETCH_MULTIPLIER = 1

# Celery Broker
CELERY_BROKER_TRANSPORT = ENV_TOKENS.get("CELERY_BROKER_TRANSPORT", "")
CELERY_BROKER_HOSTNAME = ENV_TOKENS.get("CELERY_BROKER_HOSTNAME", "")
CELERY_BROKER_VHOST = ENV_TOKENS.get("CELERY_BROKER_VHOST", "")
CELERY_BROKER_USER = AUTH_TOKENS.get("CELERY_BROKER_USER", "")
CELERY_BROKER_PASSWORD = AUTH_TOKENS.get("CELERY_BROKER_PASSWORD", "")

BROKER_URL = "{0}://{1}:{2}@{3}/{4}".format(CELERY_BROKER_TRANSPORT,
                                            CELERY_BROKER_USER,
                                            CELERY_BROKER_PASSWORD,
                                            CELERY_BROKER_HOSTNAME,
                                            CELERY_BROKER_VHOST)


# 配置celery路由
# 根据优先级不同可以配置多个队列
# CELERY_IMPORTS = ('tester_app', )
CELERY_DEFAULT_EXCHANGE = 'testapp.core'

HIGH_PRIORITY_QUEUE = 'testapp.core.high'
DEFAULT_PRIORITY_QUEUE = 'testapp.core.default'
LOW_PRIORITY_QUEUE = 'testapp.core.low'
HIGH_MEM_QUEUE = 'testapp.core.high_mem'

CELERY_DEFAULT_QUEUE = DEFAULT_PRIORITY_QUEUE
CELERY_DEFAULT_ROUTING_KEY = DEFAULT_PRIORITY_QUEUE

CELERY_QUEUES = {
    HIGH_PRIORITY_QUEUE: {},
    LOW_PRIORITY_QUEUE: {},
    DEFAULT_PRIORITY_QUEUE: {},
    HIGH_MEM_QUEUE: {},
}

# 这里并没有写Router Class，需要在views.py 使用@task(queue='')中配置

###################################################################
