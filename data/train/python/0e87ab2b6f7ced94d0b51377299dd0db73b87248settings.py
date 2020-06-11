# -*- coding: utf-8 -*-

# Scrapy settings for insights project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/en/latest/topics/settings.html
#
import os

BOT_NAME = 'insights'

SPIDER_MODULES = ['insights.spiders']
NEWSPIDER_MODULE = 'insights.spiders'

ITEM_PIPELINES = {
    'insights.pipelines.RabbitMQPipeline': 100,
}

# RabbitMQ Config
try:
    BROKER_HOST = os.environ['BROKER_HOST']
except KeyError:
    BROKER_HOST = 'localhost'

try:
    BROKER_PORT = os.environ['BROKER_PORT']
except KeyError:
    BROKER_PORT = 5672

try:
    BROKER_USERID = os.environ['BROKER_USERID']
except KeyError:
    BROKER_USERID = 'guest'

try:
    BROKER_PASSWORD = os.environ['BROKER_PASSWORD']
except KeyError:
    BROKER_PASSWORD = 'guest'

try:
    BROKER_VIRTUAL_HOST = os.environ['BROKER_VIRTUAL_HOST']
except KeyError:
    BROKER_VIRTUAL_HOST = '/'

# Crawl responsibly by identifying yourself (and your website) on the user-agent
#USER_AGENT = 'insights (+http://www.yourdomain.com)'
