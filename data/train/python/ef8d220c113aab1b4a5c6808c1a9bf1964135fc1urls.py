from django.conf.urls.defaults import *

urlpatterns = patterns('bzrwc.views',
    url(r'^$', 'repository_list',
        name='repository-list'),
    url(r'^(?P<username>[0-9A-Za-z-_]+)/$', 'repository_list',
        name='repository-list-user'),
    url(r'^(?P<username>[0-9A-Za-z-_]+)/(?P<repository_slug>[0-9a-z-_]+)/$',
        'repository_details', name='repository-details'),
    url(r'^(?P<username>[0-9A-Za-z-_]+)/(?P<repository_slug>[0-9a-z-_]+)/(?P<chart_slug>[0-9a-z-_]+)/$',
        'chart', name='chart'),
)
