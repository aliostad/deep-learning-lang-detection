from django.conf.urls import patterns, include, url
from django.contrib import admin
from tastypie.api import Api
from ricotta.api import UserResource, LocationResource, ShiftResource, PlannerBlockResource

v1_api = Api(api_name = 'v1')
v1_api.register(UserResource())
v1_api.register(LocationResource())
v1_api.register(ShiftResource())
v1_api.register(PlannerBlockResource())

admin.autodiscover()

urlpatterns = patterns('',
    url(r'^api/', include(v1_api.urls)),                    
    url(r'^ricotta/', include('ricotta.urls')),
    url(r'^admin/', include(admin.site.urls)),
    url(r'^', include('cms.urls')),
)
