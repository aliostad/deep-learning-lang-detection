from django.conf.urls.defaults import *

urlpatterns = patterns('incident.views',
    url(r'^stats/$', 'incident_stats', name="incident_stats"),
    url(r'^create/$', 'create', name="incident_create"),
    url(r'^your_incident/$', 'your_incidents', name="your_incidents"),
    url(r'^incident/(?P<incident_id>[-\w]+)/$', 'incident', name="incident_detail"),
    url(r'^manage/$', 'manage', name="incident_manage"),
    url(r'^incident/(?P<incident_id>[-\w]+)/edit/$', 'edit', name="incident_edit"),
    url(r'^incident/(?P<incident_id>[-\w]+)/delete/$', 'delete', name="incident_delete"),
)
