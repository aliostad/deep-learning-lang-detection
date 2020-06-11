from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

from tastypie.api import Api
from DenaliWebAPI.api import ParentResource, KidResource, ChoreResource
from ChopChore import views

v1_api = Api(api_name='v1')
v1_api.register(ParentResource())
v1_api.register(KidResource())
v1_api.register(ChoreResource())

urlpatterns = patterns('',

    url(r'^admin/', include(admin.site.urls)),
    url(r'^api/', include(v1_api.urls)),
    url(r'^api/v1/parents_activities/', views.upload_file),
)
