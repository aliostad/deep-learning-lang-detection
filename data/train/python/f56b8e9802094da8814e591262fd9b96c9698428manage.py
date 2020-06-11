#!/usr/bin/env python3
#-*- codin:utf-8 -*-
'''
用django + celery + redis演示异步队列任务。
不过文章写的太简略了，文章没啥意思，水平到了可以直接看代码。

python manage.py migrate -- looks at the INSTALLED_APPS setting and creates any necessary database tables according to the database settings in your mysite/settings.py file and the database migrations shipped with the app
python manage.py runserver  -- 启动
python manage.py startapp app_name -- 创建
python manage.py makemigrations app_name -- 预览
python manage.py sqlmigrate app_name 0001 -- 真干
'''
import os
import sys

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "picha.settings")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
