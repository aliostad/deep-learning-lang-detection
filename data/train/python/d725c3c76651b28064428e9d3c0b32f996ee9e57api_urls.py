from django.conf.urls import include, url
from versionmonitor.controller import api_controller

__author__ = 'dsv'

urlpatterns = [
    url(r'^project/$', api_controller.index, name='api_index'),

    url(r'^project/(?P<project_id>[0-9]+)$', api_controller.project_details, name='api_project_details'),

    url(r'^project/(?P<project_id>[0-9]+)/(?P<version_integer>[0-9]+)/icon$', api_controller.version_icon,
        name='api_version_icon'),

    url(r'^project/(?P<project_id>[0-9]+)/(?P<version_integer>[0-9]+)/apk$', api_controller.get_apk,
        name='api_version_apk'),

    url(r'^login$', api_controller.login, name='login')
]
