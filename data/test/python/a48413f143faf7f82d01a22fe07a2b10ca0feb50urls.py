# -*- coding: utf-8 -*-
from django.conf.urls.defaults import url, patterns


urlpatterns = patterns('brigitte.repositories.views',
    url(r'^$', 'overview', name='repositories_overview'),

    url(r'^manage/add/$', 'manage_add',
        name='repositories_manage_add'),
    url(r'^(?P<user>[\w-]+)/(?P<slug>[\w-]+)/manage/$',
        'manage_change',
        name='repositories_manage_change'),
    url(r'^(?P<user>[\w-]+)/(?P<slug>[\w-]+)/delete/$',
        'manage_delete',
        name='repositories_manage_delete'),

    url(r'^(?P<user>[\w-]+)/(?P<slug>[\w-]+)/$', 'summary',
        name='repositories_summary'),

    url(r'^(?P<user>[\w-]+)/(?P<slug>[\w-]+)/heads/$', 'heads',
        name='repositories_heads'),
)
