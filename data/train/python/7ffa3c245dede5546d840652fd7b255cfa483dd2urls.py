from django.conf.urls import *

urlpatterns = patterns('picard.Jan.views',
                       (r'^$', 'index'),
                       (r'^history$', 'history'),
                       (r'^content/(?P<id>\d+)/$', 'content'),
                       (r'^history_content/(?P<id>\d+)/$', 'history_content'),
                       (r'^api$', 'api'),
                       (r'^api/schedule$', 'schedule'),
                       (r'^api/trigger$', 'trigger'),
                       (r'^api/faults$', 'faults'),
                       (r'^api/btsbuilds$', 'btsbuilds'),
                       (r'^mock', 'mock'),
)