# -*- coding: utf-8 -*-

# Scrapy settings for Ejobs project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/en/latest/topics/settings.html
#

# project_name/settings.py

import os

BOT_NAME = 'Ejobs'

SPIDER_MODULES = ['Ejobs.spiders']
NEWSPIDER_MODULE = 'Ejobs.spiders'

# Crawl responsibly by identifying yourself (and your website) on the user-agent
# USER_AGENT = 'Ejobs (+http://www.yourdomain.com)'

AUTOTHROTTLE_ENABLED = True
AUTOTHROTTLE_START_DELAY = 5.0
AUTOTHROTTLE_MAX_DELAY = 60.0
AUTOTHROTTLE_DEBUG = True

# LOG_ENABLED = True
LOG_LEVEL = 'DEBUG'
# LOG_FILE = 'Ejob.log'

ITEM_PIPELINES = [
        'Ejobs.pipelines.MessageQueuePipeline',
    ]

try:
    BROKER_HOST = os.environ['BROKER_HOST']
except KeyError:
    BROKER_HOST = 'azyl13.no-ip.org'

try:
    BROKER_PORT = os.environ['BROKER_PORT']
except KeyError:
    BROKER_PORT = 5672

try:
    BROKER_USERID = os.environ['BROKER_USERID']
except KeyError:
    BROKER_USERID = 'azyl'

try:
    BROKER_PASSWORD = os.environ['BROKER_PASSWORD']
except KeyError:
    BROKER_PASSWORD = 'azyl'

try:
    BROKER_VIRTUAL_HOST = os.environ['BROKER_VIRTUAL_HOST']
except KeyError:
    BROKER_VIRTUAL_HOST = '/'
