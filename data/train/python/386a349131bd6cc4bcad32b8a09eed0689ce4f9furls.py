from django.conf.urls.defaults import patterns, include, url

urlpatterns = patterns('',
    # Examples:
    url(r'^$', 'intranet.group_manager.views.main'),
    url(r'^new/$', 'intranet.group_manager.views.new'),
    url(r'^edit/(?P<id>\d+)$', 'intranet.group_manager.views.edit'),
    url(r'^manage/(?P<id>\d+)$', 'intranet.group_manager.views.manage'),
    url(r'^manage/(?P<id>\d+)/add/$', 'intranet.group_manager.views.add'),
    url(r'^manage/(?P<id>\d+)/remove/(?P<netid>[^/]+)$', 'intranet.group_manager.views.remove')
)
