from django.conf.urls import patterns, include, url
from django.contrib import admin

from tastypie.api import Api
from guy.api import GuyResource, PositionResource
guy_api = Api(api_name='g')
guy_api.register(GuyResource())
guy_api.register(PositionResource())

urlpatterns = patterns('',
                       url(r'^guy/', include('guy.urls', namespace="guy")),
                       url(r'^admin/', include(admin.site.urls)),
                       url(r'^api/', include(guy_api.urls)),
                       )
