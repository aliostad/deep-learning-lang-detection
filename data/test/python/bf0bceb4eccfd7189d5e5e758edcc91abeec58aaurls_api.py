from django.conf.urls.defaults import *
from django.conf import settings

from tastypie.api import Api
from course_info_api.api import CourseResource, SemesterDetailsResource

#person_resource = PersonResource()
#faculty_member_resource = FacultyMemberResource()

v1_api = Api(api_name='v1')
v1_api.register(CourseResource())
v1_api.register(SemesterDetailsResource())

# Tastypie api
urlpatterns = patterns(
  '',

  (r'^courses/', include(v1_api.urls)),

)

#http://www.mcb.harvard.edu/mcb/mcb-api/directory/v1/person/1339/?format=json
