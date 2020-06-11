from django.conf.urls import patterns, include, url
from django.contrib import admin

from tastypie.api import Api

from agilegame.api import (GameResource, ActionResource, GremlinResource,
                           RoundResource)


admin.autodiscover()

v1_api = Api(api_name='v1')
v1_api.register(GameResource())
v1_api.register(ActionResource())
v1_api.register(GremlinResource())
v1_api.register(RoundResource())

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),
    url(r'^$', 'agilegame.views.index', name='index'),
    url(r'^api/', include(v1_api.urls)),
)
