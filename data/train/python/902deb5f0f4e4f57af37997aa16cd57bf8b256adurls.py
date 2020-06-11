from django.conf.urls.defaults import patterns, url, include
from tastypie.api import Api
from library.api import BookResource, FacultyResource, TeamResource, DepartmentResource, TeacherResource, StudentResource, AuthorResource, IssueResource


api_v1 = Api(api_name='v1')
api_v1.register(BookResource())
api_v1.register(FacultyResource())
api_v1.register(TeamResource())
api_v1.register(DepartmentResource())
api_v1.register(TeacherResource())
api_v1.register(StudentResource())
api_v1.register(AuthorResource())
api_v1.register(IssueResource())

urlpatterns = patterns('library.views',
    url(r'^api/', include(api_v1.urls)),
)