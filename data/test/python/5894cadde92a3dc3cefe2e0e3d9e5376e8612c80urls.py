from django.conf.urls import patterns, url

from administrator import views

urlpatterns = patterns('',
    # ex: /json_api/
    url(r'^$', views.index, name='index'),
    url(r'^login/?$', views.login, name='login'),
    url(r'^logout/?$', views.logout, name='logout'),
    
    #url(r'^edit_info/?$', views.edit_info, name='edit_info'),
    
    url(r'^statistic?/$', views.statistic, name='statistic'),
    url(r'^manage_account?/$', views.manage_account, name='manage_account'),
    url(r'^edit_account?/$', views.edit_account, name='edit_account'),
    
    url(r'^send_message?/$', views.send_message, name='send_message'),
    #url(r'^manage_message?/$', views.manage_message, name='manage_message'),
    #url(r'^manage_transaction?/$', views.manage_transaction, name='manage_transaction'),
)