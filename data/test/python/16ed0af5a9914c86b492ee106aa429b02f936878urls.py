# coding: utf-8

from django.conf.urls import patterns, url

urlpatterns = patterns('pydesk.apps.configuration.user.views',
    url(r'^/list[/]?$', 'user_list', name='user_list'),
    url(r'^/edit[/]?$', 'user_edit', name='user_edit'),
    url(r'^/add[/]?$', 'user_add', name='user_add'),
    url(r'^/ajax/list[/]?$', 'user_ajax_list', name='user_ajax_list'),
    url(r'^/ajax/add/save[/]?$', 'user_ajax_add_save', name='user_ajax_add_save'),
    url(r'^/ajax/edit/save[/]?$', 'user_ajax_edit_save', name='user_ajax_edit_save'),

    url(r'^/enterprise/edit[/]?$', 'user_enterprise_edit', name='user_enterprise_edit'),
    url(r'^/enterprise/ajax/edit/save[/]?$', 'user_enterprise_ajax_edit_save', name='user_enterprise_ajax_edit_save'),

    url(r'^/equip/edit[/]?$', 'user_equip_edit', name='user_equip_edit'),
    url(r'^/equip/ajax/edit/save[/]?$', 'user_equip_ajax_edit_save', name='user_equip_ajax_edit_save'),

    url(r'^/project/edit[/]?$', 'user_project_edit', name='user_project_edit'),
    url(r'^/project/ajax/edit/save[/]?$', 'user_project_ajax_edit_save', name='user_project_ajax_edit_save'),

)
