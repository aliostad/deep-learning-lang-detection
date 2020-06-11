from django.conf.urls.defaults import *
from socialize.client.resources import ApplicationResource, \
    ApiUserResource, CommentResource, EntityResource, LikeResource,\
    ShareResource, ViewResource
from tastypie.api import Api

v1_api = Api(api_name='v1')
v1_api.register(ApplicationResource())
v1_api.register(ApiUserResource())
v1_api.register(EntityResource())
# Activites
v1_api.register(CommentResource())
v1_api.register(LikeResource())
v1_api.register(ShareResource())
v1_api.register(ViewResource())

urlpatterns = patterns('',
    (r'^', include(v1_api.urls)),
)