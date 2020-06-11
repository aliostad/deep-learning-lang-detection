from django.conf.urls.defaults import *
from views import *

urlpatterns = patterns('',
    url(r'^manage/$', manage, name='presentation-manage'),
    url(r'^create/$', create, name='presentation-create'),
    url(r'^edit/(?P<id>\d+)/(?P<name>[-\w]+)/$', edit, name='presentation-edit'),
    url(r'^duplicate/(?P<id>\d+)/(?P<name>[-\w]+)/$', duplicate, name='presentation-duplicate'),
    url(r'^browse/$', browse, name='presentation-browse'),
    url(r'^password/(?P<id>\d+)/(?P<name>[-\w]+)/$', password, name='presentation-password'),
    url(r'^record-usage/(?P<id>\d+)/(?P<name>[-\w]+)/$', record_usage, name='presentation-record-usage'),
)
