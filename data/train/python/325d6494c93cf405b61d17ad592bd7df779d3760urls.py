from django.conf.urls import patterns, include, url
from django.contrib import admin

urlpatterns = patterns('',
    
    # Master: Index 
    url(r'^$', 'master.views.IndexView', name='index'), 
    url(r'^signup$', 'master.views.SignUpView', name='signup'),
    url(r'^login$', 'master.views.LoginView', name='login'),
    url(r'^logout$', 'master.views.LogoutView', name='logout'),

    # Master: Dashboard
    url(r'^dashboard/(?P<username>\w+)$', 'master.views.DashboardView', name='dashboard'),


    # Master: Event
    url(r'^dashboard/(?P<username>\w+)/event-manage/add/$', 'master.views.EventManageAddView', name='master-event-manage-add'),
    url(r'^dashboard/(?P<username>\w+)/event-manage/delete/(?P<eventid>\d+)$', 'master.views.EventManageDeleteView', name='master-event-manage-delete'),
    url(r'^dashboard/(?P<username>\w+)/event-manage/update/(?P<eventid>\d+)$', 'master.views.EventManageUpdateView', name='master-event-manage-update'),


    # Master: Todo
    url(r'^dashboard/(?P<username>\w+)/todo-manage/add/$', 'master.views.TodoManageAddView', name='master-todo-manage-add'),
    url(r'^dashboard/(?P<username>\w+)/todo-manage/done/(?P<todoid>\d+)$', 'master.views.TodoManageDoneView', name='master-todo-manage-done'),
    url(r'^dashboard/(?P<username>\w+)/todo-manage/delete/(?P<todoid>\d+)$', 'master.views.TodoManageDeleteView', name='master-todo-manage-delete'),
    url(r'^dashboard/(?P<username>\w+)/todo-manage/update/(?P<todoid>\d+)$', 'master.views.TodoManageUpdateView', name='master-todo-manage-update'),

    # Master: 10K Hours
    url(r'^dashboard/(?P<username>\w+)/10khours-manage/add/$', 'master.views.HoursManageAddView', name='master-hours-manage-add'),
    url(r'^dashboard/(?P<username>\w+)/10khours-manage/delete/(?P<trackerid>\d+)$', 'master.views.HoursManageDeleteView', name='master-hours-manage-delete'),
    url(r'^dashboard/(?P<username>\w+)/10khours-manage/update/(?P<trackerid>\d+)$', 'master.views.HoursManageUpdateView', name='master-hours-manage-update'),

    # Master: Mood
    url(r'^dashboard/(?P<username>\w+)/mood-manage/add/$', 'master.views.MoodManageAddView', name='master-mood-manage-add'),
    url(r'^dashboard/(?P<username>\w+)/mood-manage/delete/(?P<moodid>\d+)$', 'master.views.MoodManageDeleteView', name='master-mood-manage-delete'),
    url(r'^dashboard/(?P<username>\w+)/mood-manage/update/(?P<moodid>\d+)$', 'master.views.MoodManageUpdateView', name='master-mood-manage-update'),

    # Master: Dream
    url(r'^dashboard/(?P<username>\w+)/dream-manage/add/$', 'master.views.DreamManageAddView', name='master-dream-manage-add'),
    url(r'^dashboard/(?P<username>\w+)/dream-manage/delete/(?P<dreamid>\d+)$', 'master.views.DreamManageDeleteView', name='master-dream-manage-delete'),
    url(r'^dashboard/(?P<username>\w+)/dream-manage/update/(?P<dreamid>\d+)$', 'master.views.DreamManageUpdateView', name='master-dream-manage-update'),

    # Master: Diary
    url(r'^dashboard/(?P<username>\w+)/diary-manage/add/$', 'master.views.DiaryManageAddView', name='master-diary-manage-add'),
    url(r'^dashboard/(?P<username>\w+)/diary-manage/delete/(?P<diaryid>\d+)$', 'master.views.DiaryManageDeleteView', name='master-diary-manage-delete'),
    url(r'^dashboard/(?P<username>\w+)/diary-manage/update/(?P<diaryid>\d+)$', 'master.views.DiaryManageUpdateView', name='master-diary-manage-update'),



    # Apps
    url(r'^dashboard/(?P<username>\w+)/todo/$', include('todo.urls')),


    # Admin
    url(r'^admin/', include(admin.site.urls)),
)
