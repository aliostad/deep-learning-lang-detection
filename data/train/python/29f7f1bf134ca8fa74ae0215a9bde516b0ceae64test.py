#!/usr/bin/env python
#coding:utf-8
#================================================================
#   Copyright (C) 2013 All rights reserved.
#   
#   文件名称：test.py
#   创 建 者：许培源
#   创建日期：2013年06月26日
#   描    述：
#
#   更新日志：
#
#================================================================
import os
import sys
reload(sys) 
sys.setdefaultencoding('utf8') 

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "game_manage.settings.local")
sys.path.append('/opt/py_env/feiyin/game_manage/game_manage')
import game_manage
from server.models import Server


if __name__ == "__main__":
    myserver = Server.objects.get(pk=1)
    print myserver
    for key, value in  myserver.get_fields():
        print '%s : %s' %(key, value)

