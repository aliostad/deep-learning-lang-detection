from django.conf.urls.defaults import *
from django.contrib.auth.views import login, logout
import settings
import adaptivelearning
import courses.views as courseviews

urlpatterns = patterns('',
    # Example:
    # (r'^adaptivelearnin/', include('adaptivelearning.foo.urls')),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

		(r'^course/show/(.*)/$', courseviews.course_show),
		(r'^course/topic/show/(.*)/(.*)$',courseviews.topic_show),
		(r'^manage/$', courseviews.manage),
		(r'^manage/courses/$', courseviews.course_manager),
		(r'^manage/courses/reorder/$', courseviews.courses_reorder),
		(r'^manage/course/$', courseviews.course_manager),
		(r'^manage/course/add/$', courseviews.course_add),
		(r'^manage/course/edit/(.*)$', courseviews.course_edit),
		(r'^manage/course/deletes/$', courseviews.course_delete),
		(r'^manage/course/topic/add/(.*)$', courseviews.topic_add),
		#(r'^manage/course/topic/show/$', topic_show),
		(r'^manage/course/topic/edit/(.*)/(.*)$',courseviews.topic_edit),
		(r'^manage/course/topic/edit/$', courseviews.topic_edit_save),
		(r'^manage/course/topic/deletes/(.*)$',courseviews.topic_delete),
		(r'^manage/course/topic/reorder/(.*)/$',courseviews.topic_reorder),
)
