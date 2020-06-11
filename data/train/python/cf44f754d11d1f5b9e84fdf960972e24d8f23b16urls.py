from django.conf.urls import patterns, include, url

from django.contrib import admin
from tastypie.api import Api
from lecture.api.resources import StudentResource, ClassResource, VersionResource, StudentProjectResource, MediaResource

admin.autodiscover()

v1_api = Api(api_name="v1")
v1_api.register(StudentResource())
v1_api.register(ClassResource())
v1_api.register(StudentProjectResource())
v1_api.register(VersionResource())
v1_api.register(MediaResource())



urlpatterns = patterns('',
    url(r'^$', 'lecture.views.presentation', name="presentation"),

    url(r'^api/', include(v1_api.urls)),

    url(r'^admin/', include(admin.site.urls)),

    url(r'api/lecture/doc/',
        include('tastypie_swagger.urls', namespace='tastypie_swagger'),
        kwargs={"tastypie_api_module": "v1_api",
                "namespace": "lecture_tastypie_swagger"}
    ),
)
