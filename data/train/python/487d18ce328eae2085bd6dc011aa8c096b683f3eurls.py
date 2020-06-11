'''
Created on 17/10/2012

@author: arruda
'''
from django.conf.urls.defaults import patterns, include, url


urlpatterns = patterns('projects.views',
#    url(r'^$', 'index'),
#    url(r'^exibir/(?P<template_id>\d+)/$', 'exibir',name='exibir_avaliacao'),    ,  
   
    url(r'^$', 'manage_projects', name='manage_projects'),     
    url(r'^add/$', 'add_project', name='add_project'),     
    
    url(r'^(?P<project_id>\d+)/tasks/add_task/$', 'add_task',name='add_task'),    
)

#tasks only
urlpatterns += patterns('projects.views',
    url(r'^tasks/$', 'manage_tasks', name='manage_tasks'),    
)