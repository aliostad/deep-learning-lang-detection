# -*- coding: utf-8 -*-

from django.conf.urls.defaults import patterns, url
from module.manage.ajax import get_title_list, get_subcategory_list, get_volume_list, get_writer_list, get_publisher_list

urlpatterns = patterns(
    'module.manage.views',
    url(r'^$', 'index', name='manage_index'),
    url(r'^index/(?P<set_type>\w+)/$', 'index', name='manage_index'),
    url(r'^regist/(?P<set_type>\w+)/$', 'regist', name='manage_regist'),
    url(r'^edit/(?P<set_type>\w+)/(?P<edit_id>\d+)/$', 'edit', name='manage_edit'),
    url(r'^delete/(?P<set_type>\w+)/(?P<del_id>\d+)/$', 'delete', name='manage_delete'),
    url(r'^delete_checked/(?P<set_type>\w+)/$', 'delete_checked', name='manage_delete_checked'),
    url(r'^search/(?P<set_type>\w+)/$', 'search', name='manage_search'),
    url(r'^status/$', 'status', name='manage_status'),
    url(r'^upload/$', 'upload', name='manage_upload'),

    url(r'^ajax/book_title/$', get_title_list, name='manage_get_title_list'),
    url(r'^ajax/book_subcategory/$', get_subcategory_list, name='manage_get_subcategory_list'),
    url(r'^ajax/book_volume/$', get_volume_list, name='manage_get_volume_list'),
    url(r'^ajax/book_writer/$', get_writer_list, name='manage_get_writer_list'),
    url(r'^ajax/book_publisher/$', get_publisher_list, name='manage_get_publisher_list'),
)
