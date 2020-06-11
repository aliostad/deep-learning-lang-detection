#!/usr/bin/env python3
#-*- coding:utf-8 -*-
'''
django提供的样例，一个投票程序。这个例子还不错，教程写的也详细，适合入门看。
使用python3和django1.8
是学习django的入门例子

python manage.py migrate -- looks at the INSTALLED_APPS setting and creates any necessary database tables according to the database settings in your mysite/settings.py file and the database migrations shipped with the app
python manage.py runserver  -- 启动
python manage.py startapp app_name -- 创建
python manage.py makemigrations app_name -- 预览
python manage.py sqlmigrate app_name 0001 -- 真干
'''
import os
import sys

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "django_poll.settings")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
