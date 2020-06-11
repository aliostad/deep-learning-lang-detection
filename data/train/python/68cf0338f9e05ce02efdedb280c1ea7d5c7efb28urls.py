#!/usr/bin/env python
#-*-coding:utf-8-*-
# ---------------------------------
# create-time:      <2009/01/23 13:29:20>
# last-update-time: <halida 02/03/2009 20:36:18>
# ---------------------------------
# 

from django.conf.urls.defaults import *

urlpatterns = patterns('myblog.views',
                       (r'^$', 'mainpage'),
                       #管理博客
                       (r'^manage/$','manage_blog'),
                       (r'^(?P<blog_name>\w+)/update/$','manage_blog'),
                       (r'^(?P<blog_name>\w+)/delete/(?P<confirm>\w+)/$','delete_blog'),
                       #管理文章
                       (r'^(?P<blog_name>\w+)/manage/$','manage_article'),
                       (r'^(?P<blog_name>\w+)/(?P<article_id>\d+)/update/$','manage_article'),
                       (r'^(?P<blog_name>\w+)/(?P<article_id>\d+)/delete/(?P<confirm>\w+)/$','delete_article'),
                       #博客显示
                       (r'^(?P<blog_name>\w+)/$','show'),
                       (r'^(?P<blog_name>\w+)/(?P<article_id>\d+)/$', 'show'),
                       )
