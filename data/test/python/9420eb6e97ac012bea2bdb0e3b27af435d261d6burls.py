from django.conf.urls import patterns, include, url
from django.contrib import admin
from tastypie.api import Api
from course.api import UserResource, CourseResource, CourseProgressResource
from subscription.api import SubscriptionResource
from userprofile.api import UserProfileResource
from material.api import LectureResource, QuizResource, QuizResultResource, LabResource
from newsfeed.api import NewsResource

v1_api = Api(api_name = 'v1')
v1_api.register(UserResource())
v1_api.register(CourseResource())
v1_api.register(CourseProgressResource())
v1_api.register(UserProfileResource())
v1_api.register(SubscriptionResource())
v1_api.register(LectureResource())
v1_api.register(QuizResource())
v1_api.register(QuizResultResource())
v1_api.register(LabResource())
v1_api.register(NewsResource())

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),
    url(r'^auth/', include('service_auth.urls')),
    url(r'^reg/', include('service_reg.urls')),
    url(r'^emails/', include('emailnews.urls')),
    url(r'^api/', include(v1_api.urls)),
)
