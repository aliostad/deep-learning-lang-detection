from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

from tastypie.api import Api

from projects.api import ProjectResource
from items.api import ItemResource

v1_api = Api(api_name='v1')
v1_api.register(ProjectResource())
v1_api.register(ItemResource())

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'arpostits.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^api/', include(v1_api.urls)),
)
