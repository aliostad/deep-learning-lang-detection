from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'fdvworkflow.views.home', name='home'),
    # url(r'^fdvworkflow/', include('fdvworkflow.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^$','supermilai.views.index'),
    #url(r'^register.html','account.views.account_register'),
    url(r'^login.html','account.views.account_login'),
    url(r'^logout.html','account.views.account_logout'),
    url(r'^password_change.html$','account.views.account_password_change'),
    url(r'^profile/view.html','account.views.account_view_profile'),
    url(r'^profile/edit/id=(.+)$','account.backend_manage.user_modify'),

    url(r'^manage/user_list.html','account.backend_manage.user_list'),
    url(r'^manage/add_user.html$','account.backend_manage.user_add'),
    url(r'^manage/modify/user/id=(.+)$','account.backend_manage.user_modify'),
    url(r'^manage/remove/user/id=(.+)$','account.backend_manage.user_remove'),

    url(r'^manage/group_list.html','account.backend_manage.group_list'),
    url(r'^manage/add_group.html$','account.backend_manage.group_add'),
    url(r'^manage/modify/group/id=(.+)$','account.backend_manage.group_modify'),
    url(r'^manage/remove/group/id=(.+)$','account.backend_manage.group_remove'),

    url(r'^manage/permission_list.html','account.backend_manage.permission_list'),
    url(r'^manage/add_permission.html$','account.backend_manage.permission_add'),
    url(r'^manage/modify/permission/id=(.+)$','account.backend_manage.permission_modify'),
    #url(r'^manage/remove/user/id=(.+)$','account.backend_manage.user_remove'),

    url(r'^ajax/set_active_status.html','account.ajax.set_active_status'),
    url(r'^ajax/set_group.html','account.ajax.set_group'),
    #url(r'^account_manage.html$','account.views.account_manage'),
    #url(r'^account_manage/add_group.html$','account.views.add_group'),
    #url(r'^account_manage/modify_group/modify/id=(.+)$','account.views.modify_group'),
    #url(r'^account_manage/delete_group.html$','account.views.delete_group'),
)
