from django.conf.urls.defaults import *

urlpatterns = patterns('lesson.views',
	(r'^curriculum/new/$', 'new_curriculum'),
	(r'^curriculum/show/$', 'show_curriculum'),
	(r'^curriculum/show/(?P<id>[0-9]+)/$', 'show_curriculum'),
	(r'^curriculum/show/(?P<id>[0-9]+)/(?P<saveMsg>[yYNn])/$', 'show_curriculum'),
	(r'^curriculum/saveNew/$', 'save_new_curriculum'),
	(r'^curriculum/saveExisting/$', 'save_existing_curriculum'),
	(r'^curriculum/list/$', 'list_curriculum'),

	(r'^lesson/new/(?P<curriculum_id>[0-9]+)/$', 'new_lesson'),
	(r'^lesson/show/$', 'show_lesson'),
	(r'^lesson/show/(?P<id>[0-9]+)/$', 'show_lesson'),
	(r'^lesson/saveNew/$', 'save_new_lesson'),
	(r'^lesson/saveNew/(?P<curriculum_id>[0-9]+)/$', 'save_new_lesson'),
	(r'^lesson/saveExisting/$', 'save_existing_lesson'),
)
