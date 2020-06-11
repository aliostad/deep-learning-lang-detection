from django.conf.urls import patterns, include, url
from django.contrib import admin
from tastypie.api import Api

from app.api import NoteResource, ProjectResource, VersionResource

sg_api = Api(api_name='v3')
sg_api.register(NoteResource())
sg_api.register(ProjectResource())
sg_api.register(VersionResource())

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'example.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    url(r'^api/', include(sg_api.urls)),
    url(r'^admin/', include(admin.site.urls)),
    url(r'^', include('app.urls')),
)
