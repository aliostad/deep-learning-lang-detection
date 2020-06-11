from django.conf.urls.defaults import *
from api import OrganizationResource, UserProfileResource, CourseResource, ProblemResource, EssayResource, EssayGradeResource, UserResource, CreateUserResource, MembershipResource
from tastypie.api import Api

v1_api = Api(api_name='v1')
v1_api.register(OrganizationResource())
v1_api.register(UserProfileResource())
v1_api.register(CourseResource())
v1_api.register(ProblemResource())
v1_api.register(EssayResource())
v1_api.register(EssayGradeResource())
v1_api.register(UserResource())
v1_api.register(CreateUserResource())
v1_api.register(MembershipResource())

urlpatterns = patterns('',
    (r'^api/', include(v1_api.urls)),
)