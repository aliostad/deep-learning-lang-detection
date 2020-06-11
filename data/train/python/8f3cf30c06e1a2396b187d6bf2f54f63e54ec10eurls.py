from django.conf.urls import patterns, url


urlpatterns = patterns('',

    url(r'^$', 'projects.views.home', name='home'),
    url(r'^main-data/', 'projects.views.main_data', name='main-data'),
    url(r'^activity-status/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$',\
                'projects.views.manage_activity_status', name='manage_activity_status'),
    url(r'^coordinator-type/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$',\
                'projects.views.manage_coordinator_type', name='manage_coordinator_type'),
    url(r'^project-type/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$',\
                'projects.views.manage_project_type', name='manage_project_type'),
    url(r'^activity-type/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$',\
                'projects.views.manage_activity_type', name='manage_activity_type'),

    url(r'^project/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$',\
                'projects.views.manage_project', name='manage_project'),
    url(r'^coordinator/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$',\
                'projects.views.manage_project_coordinator', name='manage_project_coordinator'),
    url(r'^budget-head/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$',\
                'projects.views.manage_budget_head', name='manage_budget_head'),
    url(r'^milestone/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$',\
                'projects.views.manage_milestone', name='manage_milestone'),

    url(r'^training/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$',\
                'projects.views.manage_project_training', name='manage_project_training'),

    url(r'^strategy/(?P<value>(:?add|:?edit|:?active|:?delete)|:?cancel)/$',\
                'projects.views.manage_strategy', name='manage_strategy'),

    url(r'^activity/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$',\
                'projects.views.manage_activity', name='manage_activity'),

    url(r'^details/$', 'projects.views.manage_project_details', name='manage_project_details'),
    url(r'^get_training/$', 'projects.views.get_training', name='get_training'),
    url(r'^get_strategy/$', 'projects.views.get_strategy', name='get_strategy'),
    url(r'^project-filters/$', 'projects.views.project_filters', name='project_filters'),
    url(r'^get_strategy/$', 'projects.views.get_strategy', name='get_strategy'),

)
