#!/usr/bin/env python
# vim: ai ts=4 sts=4 et sw=4 coding=utf-8
# maintainer: dgelvin, ukanga

import time

from django.conf import settings

import djcelery

INSTALLED_APPS.extend([
    'django.contrib.admin',
    'reversion',
    'django_extensions',
    'south',
    'djcelery',
    'alerts'
])

DEBUG = TEMPLATE_DEBUG = False

CELERY_DISABLE_RATE_LIMITS = True

BROKER_HOST = "localhost"
BROKER_PORT = 5672
BROKER_USER = "mvp"
BROKER_PASSWORD = "africa"
BROKER_VHOST = "rsmsvhost"

CELERY_RESULT_BACKEND = 'amqp'
CELERY_DISABLE_RATE_LIMITS = True
CELERY_LOADER='django'
CELERY_AMQP_TASK_RESULT_EXPIRES = 60*60
CELERY_IMPORTS = ('reportgen.definitions',)

CACHE_BACKEND = 'file:///var/cache/childcount?max_entries=10000&cull_frequency=2'

ADMIN_MEDIA_PREFIX = '/adminmedia/'

TIME_ZONE = 'Africa/Nairobi'
time.tzset()
settings.configure(**locals())
