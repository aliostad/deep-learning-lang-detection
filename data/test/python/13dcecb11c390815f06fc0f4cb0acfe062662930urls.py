#!/usr/bin/python
# -*- coding: utf-8 -*-

from django.conf.urls import patterns, url

from todo import views


urlpatterns = patterns('',

        url(r'^manage/$', views.ManageView, name='todo-manage'),
        url(r'^manage/add/$', views.ManageAddView, name='todo-manage-add'),
        url(r'^manage/done/(?P<todoid>\d+)$', views.ManageDoneView, name='todo-manage-done'),
        url(r'^manage/delete/(?P<todoid>\d+)$', views.ManageDeleteView, name='todo-manage-delete'),
        url(r'^manage/update/(?P<todoid>\d+)$', views.ManageUpdateView, name='todo-manage-update'),
 
)

