# -*- coding: utf-8 -*-
from django.conf.urls import patterns,  url

from manage.views  import frontend
# from kinger import settings

urlpatterns = patterns('',
    url('^index/$', frontend.index),
    url(r'^$', frontend.index, name='manage'),
    url(r'^login/$', 'manage.views.admin.login', name='manage_login'),
    url(r'^change_username/$', 'manage.views.admin.change_username', name="manage_change_username")
)

urlpatterns += patterns("manage.views.school",
    url(r'^school/$', "view", name='kinger_school_info'),
    url('^school/send_account/$', "send_account", name="manage_school_send_account"), 
)

#课表
urlpatterns += patterns("manage.views.schedule",
        url('^schedule/student/$', "student_index", name="manage_schedule_student"),
        url('^schedule/teacher/$', "teacher_index", name="manage_schedule_teacher"),
        url('^schedule/create/$', "create", name="manage_create_schedule"),
        url('^schedule/delete/(?P<schedule_id>\d+)/$', "delete", name="manage_delete_schedule"),
        url('^schedule/download/(?P<schedule_id>\d+)/$', "download", name="manage_download_schedule"),
)

urlpatterns += patterns("manage.views.teacher",
    url(r'^teacher/$', "index", name='manage_teacher_list'),
    url('^teacher/create/$', "create", name='manage_teacher_create'),
    url('^teacher/(?P<teacher_id>\d+)/$', "view", name='manage_teacher_view'),
    url('^teacher/(?P<teacher_id>\d+)/delete/$', "delete", name="manage_teacher_delete"),
    url('^teacher/(?P<teacher_id>\d+)/update/$', "update", name="manage_teacher_update"),
    url(r'^teacher/import/$', "imports", name='manage_teacher_import'),
    url(r'^teacher/template/$', "template", name='manage_teacher_template'),

)

urlpatterns += patterns("manage.views.student",
    url(r'^student/$', "index", name='manage_student_list'),
    url(r'^student/create/$', "create", name='manage_student_create'),
    url(r'^student/import/$', "imports", name='manage_student_import'),
    url(r'^student/template/$', "template", name='manage_student_template'),

    url('^student/(?P<student_id>\d+)/$', "view", name='manage_student_view'),
    url(r'^student/(?P<student_id>\d+)/delete/$', "delete", name="manage_student_delete"),
    url(r'^student/(?P<student_id>\d+)/update/$', "update", name="manage_student_update"),
    url(r'^student/(?P<student_id>\d+)/send_account/$', "send_account", name="manage_student_send_account"),

)

urlpatterns += patterns("manage.views.class",
    url(r'^class/$', "index", name="manage_class_list"),
    url('^class/(?P<class_id>\d+)/$', "view", name="manage_class_view"),
    url('^class/(?P<class_id>\d+)/delete/$', "delete", name="manage_class_delete"),
    url('^class/create/$', "create", name="manage_class_create"),
    url('^class/(?P<class_id>\d+)/update/$', "update", name="manage_class_update"),
    url('^class/add_student/$', "add_student", name="manage_class_add_student"),
    url('^class/add_teacher/$', "add_teacher", name="manage_class_add_teacher"),
    url('^class/(?P<class_id>\d+)/student/(?P<student_id>\d+)/remove/$', "remove_student", name="manage_class_remove_student"),
    url('^class/(?P<class_id>\d+)/teacher/(?P<teacher_id>\d+)/remove/$', "remove_teacher", name="manage_class_remove_teacher"),
)

# 食谱设置
urlpatterns += patterns("manage.views.cookbook",
    url(r'^cookbook/$', "index", name="manage_cookbook"),  
    url(r'^cookbook/get_cookbook_date/$', "get_cookbook_date", name="manage_cookbook_get_cookbook_date"),
    url(r'^cookbook/save_cookbook/$', "save_cookbook", name="manage_cookbook_save_cookbook"),
    url(r'^cookbook/save_cookbook_set/$', "save_cookbook_set", name="manage_cookbook_save_cookbook_set"),
)
