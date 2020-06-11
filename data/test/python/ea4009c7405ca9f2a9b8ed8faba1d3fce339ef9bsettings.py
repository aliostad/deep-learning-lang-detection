#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-
# Copyright (c) 2014 Asumi Kamikaze Inc.
# Licensed under the MIT License.
# Author: Alejandro M. Bernardis
# Email: alejandro (dot) bernardis (at) asumikamikaze (dot) com
# Created: 14/Oct/2014 18:46

BROKER_USER = 'celery'
BROKER_PASS = 'celery'
BROKER_URL = "amqp://%s:%s@localhost//" % (BROKER_USER, BROKER_PASS)

CELERY_RESULT_BACKEND = 'amqp'
CELERY_ENABLE_UTC = True
CELERY_IGNORE_RESULT = True
CELERY_TASK_RESULT_EXPIRES = 60 * 60 * 24

CELERY_IMPORTS = (
    'backend.background.server',
    'backend.background.tasks.track'
)

CELERY_ANNOTATIONS = {
    '*': {
        'rate_limit': '1000/m'
    }
}