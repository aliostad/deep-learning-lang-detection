from django.conf.urls import patterns, url

urlpatterns = patterns('',
    url(r'^timechart/$', 'apps.mensa_app.views.timechart', name='timechart'),
    url(r'^admin/login/$', 'apps.mensa_app.views.login', name='adminlogin'),
    url(r'^$', 'apps.timesheet.views.coming', name='coming'),
    url(r'^accounts/login/$','django.contrib.auth.views.login',{'template_name': 'login.html'}),
    url(r'^dashboard/','apps.mensa_app.views.home',name='home'),
    url(r'^logout/$', 'apps.mensa_app.views.logout'),
    url(r'^accounts/logout/$', 'django.contrib.auth.views.logout', {'template_name': 'logout.html'}),
    url(r'^accounts/checkout/$','apps.mensa_app.views.checkout',name='checkout'),

    url(r'^profile/(?P<profile_id>\w+)/$','apps.mensa_app.views.profile',name='profile'),
    url(r'^profile/(?P<profile_id>\w+)/result/$', 'apps.mensa_app.views.result', name='result'),
    url(r'^a/$','apps.mensa_app.views.a'),


)

# urlpatterns += patterns('mensa_app.views',
#     url(r'^manage/mensasystem/project/$','manage_project'),
#     url(r'^manage/mensasystem/project/data/$','manage_project_data'),
#     url(r'^manage/mensasystem/project/data/add/$','manage_project_data_add'),
#     url(r'^manage/mensasystem/project/data/edit/(?P<project_id>\d+)/$','manage_project_data_edit'),
#
#     url(r'^manage/mensasystem/task/$','manage_task'),
#     url(r'^manage/mensasystem/task/add/$','manage_task_add'),
#     url(r'^manage/mensasystem/task/edit/(?P<taskid>\d+)/$','manage_task_edit'),
#
#
# )
