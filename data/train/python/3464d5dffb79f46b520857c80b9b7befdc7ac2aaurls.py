from django.conf.urls.defaults import patterns, include, url

urlpatterns = patterns('kiwitest.students.views',
    url(r'^$', 'index', name='index'),
    url(r'^group/(\d+)/$', 'group', name='show_group'),

    url(r'^student/add/$', 'manage_student', name='add_student'),
    url(r'^student/add/(?P<group_id>\d+)/$', 'manage_student', name='add_student_to_group'),
    url(r'^student/edit/(\d+)/$', 'manage_student', name='edit_student'),

    url(r'^group/add/$', 'manage_group', name='add_group'),
    url(r'^group/edit/(\d+)/$', 'manage_group', name='edit_group'),

    url(r'^student/delete/(?P<instance_id>\d+)/',
        'delete_instance',
        name='delete_student',
        kwargs={'instance_type': 1}),

    url(r'^group/delete/(?P<instance_id>\d+)/',
        'delete_instance',
        name='delete_group',
        kwargs={'instance_type': 2}),
)
  