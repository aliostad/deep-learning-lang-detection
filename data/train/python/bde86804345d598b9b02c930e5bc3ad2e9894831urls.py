from django.conf.urls import patterns, include, url
from tastypie.api import Api
from api import CourseResource, SectionResource, LectureResource, ContentResource, AssignmentResource, NotificationResource
from course import views

# course_resource = CourseResource()

v1_api = Api(api_name='v1')
v1_api.register(CourseResource())
v1_api.register(SectionResource())
v1_api.register(LectureResource())
v1_api.register(ContentResource())
v1_api.register(AssignmentResource())
v1_api.register(NotificationResource())
# v1_api.register()
# v1_api.register()
# v1_api.register()

urlpatterns = patterns('',
	# url(r'^api/',include(v1_api.urls)),
	url(r'api/', include(v1_api.urls)),
	url(r'^createAssignment/$', views.createAssignment, name='weblogin'),
)