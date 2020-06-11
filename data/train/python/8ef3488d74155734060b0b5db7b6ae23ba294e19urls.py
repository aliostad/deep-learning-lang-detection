from django.conf.urls import patterns, include, url

from django.contrib import admin
from app import views

admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'hh_test.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
    (r'^$', views.index),
)


#Tastypie API
from tastypie.api import Api
from app.api import *

v1_api = Api(api_name='v1')

v1_api.register(AutoModelResource())
v1_api.register(UserResource())

urlpatterns += patterns('',
    (r'^api/', include(v1_api.urls)),

)