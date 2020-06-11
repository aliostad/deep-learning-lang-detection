from django.conf.urls import patterns, url


urlpatterns = patterns('',

    url(r'^$', 'budget.views.home', name='home'),
    url(r'^main-data/', 'budget.views.main_data', name='main-data'),
    url(r'^budget-activity-status/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$',\
                'budget.views.manage_activity_status'),
    url(r'^budget/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$', \
                'budget.views.manage_budget'),

    url(r'^budget-strategy/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$', \
                'budget.views.manage_budget_strategy', name='manage_budget_strategy'),

    url(r'^budget-activity/(?P<value>(:?add|:?edit|:?active|:?delete|:?cancel))/$', \
                'budget.views.manage_budget_activity', name='manage_budget_activity'),

    url(r'^details/', 'budget.views.budget_details', name="budget_details"),

    )
