
from django.conf.urls import patterns, include, url

urlpatterns = patterns('@module@.hub.apps.@plural_resource@.views',
    url(r'^$', 'list', name='list_@plural_resource@'),
    url(r'^manage/$', 'manage', name='manage_@plural_resource@'),
    url(r'^create/$', 'create', name='create_@resource@'),
    url(r'^(?P<@resource@_id>[\d]+)/$', 'details', name='@resource@_details'),
    url(r'^(?P<@resource@_id>[\d]+)/update/$', 'update', name='update_@resource@'),
    url(r'^(?P<@resource@_id>[\d]+)/delete/$', 'delete', name='delete_@resource@'),
)
