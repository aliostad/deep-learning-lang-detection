from django.conf.urls import patterns, include, url
from django.contrib import admin
from portfolio.views import *

urlpatterns = patterns('',
    url( r'^$', Display_all.as_view() ),
    url( r'^create$', Create.as_view() ),
    url( r'^tracked$', Tracked.as_view() ),
    url( r'^ticker/(?P<date>[\d\-]+)$', Ticker.as_view() ),
    url( r'^(?P<slug>[\w\-]+)/edit$', Edit.as_view() ),
    url( r'^(?P<slug>[\w\-]+)/manage$', Manage.as_view() ),
    url( r'^(?P<slug>[\w\-]+)/manage/add$', Holding_add.as_view() ),
    url( r'^(?P<slug>[\w\-]+)/manage/remove$', Holdin_remove.as_view() ),
    # url( r'(?P<slug>[\w\-]+$)', Display.as_view() ),
)
