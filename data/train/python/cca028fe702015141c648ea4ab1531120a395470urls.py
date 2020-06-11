from django.conf.urls.defaults import patterns, include, url

from tastypie.api import Api
from django.contrib import admin

from api import BoxResource, LeafResource, PersonResource
admin.autodiscover()

v1_api = Api(api_name='v1')
v1_api.register(BoxResource())
v1_api.register(LeafResource())
v1_api.register(PersonResource())

urlpatterns = patterns('',
    #url(r'^api/', include('data_store.client_api_urls')),
    (r'^$', 'core.views.index'),
    (r'^api/', include(v1_api.urls)),
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    url(r'^admin/', include(admin.site.urls)),
)
