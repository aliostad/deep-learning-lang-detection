from django.conf.urls import patterns, url, include

from tastypie.api import Api

from .api import UserResource, CreateUserResource


# Create an empty pattern so that we can just build it using +=
urlpatterns = patterns(None)

#==============================================================================
# API Resources
#==============================================================================
v1_api = Api(api_name='v1')
v1_api.register(UserResource())
v1_api.register(CreateUserResource())


urlpatterns += patterns(
    '',
    url(r'^api/', include(v1_api.urls)),
)
