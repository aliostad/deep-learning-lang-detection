# -*- coding: UTF-8 -*-
from django.conf.urls import patterns, url
from back_manager.views import manage_tongji_view,manage_home_view,manage_adshow_view,manage_manager_add_view,manage_manager_del_view
urlpatterns = patterns(
                       '',
                       url(r'^$',manage_home_view),
                       url(r'^ad/show/$',manage_adshow_view),
                       url(r'^manager/add/$',manage_manager_add_view),
                       url(r'^manager/del/$',manage_manager_del_view),
                       url(r'^tongji/$',manage_tongji_view),
                       )