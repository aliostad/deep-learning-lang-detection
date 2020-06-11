# -*- coding: utf-8 -*-

# 引入父目录来引入其他模块
import os
import sys
sys.path.extend([os.path.abspath("../"), os.path.abspath("./")])
os.environ['DJANGO_SETTINGS_MODULE'] = 'www.settings'

BROKER_BACKEND = 'redis'
BROKER_HOST = '127.0.0.1'
BROKER_PORT = 6379
BROKER_VHOST = "1"

#BROKER_URL = "redis://db0:6379/6"
#CELERY_IGNORE_RESULT = False
#CELERY_RESULT_BACKEND = "redis://db0:6379/2"
# CELERY_TASK_RESULT_EXPIRES = 18000   #5小时的结果
CELERY_IMPORTS = ("www.tasks", )


# celeryd -l WARNING -c 1 --time-limit=120 --queue=blog_worker
