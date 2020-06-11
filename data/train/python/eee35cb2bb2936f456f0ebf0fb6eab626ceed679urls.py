from django.conf.urls.defaults import *

urlpatterns = patterns('management.views',

    url(r'^manage/organization/$', 'view_managing_organization', name='view_managing_organization'),

    url(r'^manage/users/$', 'view_managing_users', name='view_managing_users'),
    url(r'^manage/users/section/$', 'view_managing_section_users', name='view_managing_section_users'),
    url(r'^manage/users/project/$', 'view_managing_project_users', name='view_managing_project_users'),

    url(r'^manage/users/add/$', 'add_managing_user', name='add_managing_user'),
    url(r'^manage/users/(?P<user_id>\d+)/add/responsibility/$', 'add_managing_user_responsibility', name='add_managing_user_responsibility'),
    url(r'^manage/users/(?P<user_id>\d+)/password/$', 'view_managing_user_password', name='view_managing_user_password'),

    url(r'^manage/users/(?P<user_id>\d+)/edit/$', 'edit_managing_user', name='edit_managing_user'),

    url(r'^manage/users/(?P<user_id>\d+)/edit/projects/$', 'edit_managing_user_projects', name='edit_managing_user_projects'),
    url(r'^ajax/remove_managing_project/$', 'ajax_remove_managing_project', name='ajax_remove_managing_project'),

    url(r'^manage/users/(?P<user_id>\d+)/deactivate/$', 'deactivate_managing_user', name='deactivate_managing_user'),
    
    
    url(r'^manage/users/import/$', 'import_managing_users', name='import_managing_users'),

    url(r'^manage/import/$', 'import_from_gms', name='import_from_gms'),
    url(r'^manage/import/details/$', 'view_manage_import_details', name='view_manage_import_details'),

)