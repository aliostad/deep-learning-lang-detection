# -*- coding: utf-8 -*-
from mosys.custom_model import AppPage,GridModel

class A_ServerManage(AppPage):
    verbose_name=u'服务监视'
    menu_grup = 'att_monitor'
    icon_class = "menu_monitor"
    template = 'server_manage.html'
    pass

class RedisQuery(AppPage):
    verbose_name=u'Redis所有数据'
    menu_grup = 'att_monitor'
    icon_class = "menu_redis"
    template = 'redis_query.html'
    pass

class FileManage(AppPage):
    verbose_name=u'文件管理'
    menu_grup = 'att_monitor'
    icon_class = "menu_file"
    template = 'file_manage.html'
    pass