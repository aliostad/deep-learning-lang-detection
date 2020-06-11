from django.conf.urls import patterns, include, url
from django.contrib import admin

from tastypie.api import Api

from eventually.api import *
from events.api import *

v1_api = Api(api_name='v1')
v1_api.register(UserResource())
v1_api.register(UserProfileResource())
v1_api.register(GoingResource())
v1_api.register(AttendingResource())
v1_api.register(EventResource())
v1_api.register(VenueResource())
v1_api.register(SessionResource())

admin.autodiscover()

urlpatterns = patterns('',
    
    url(r'^$', 'events.views.home', name='home'),
    
    
    # API
    
    url(r'^api/', include(v1_api.urls)),
    
    
    # Django admin
    
    url(r'^admin/', include(admin.site.urls)),
    
    
    # Django-registration
    
    url(r'^accounts/', include('registration.backends.default.urls')),

)
