from django.conf.urls.defaults import patterns, url

urlpatterns = patterns('myproject.camps.views',
    # Main Page
    url(r'^$', 'main_page'),

    # Registration & Login/Logout
    url(r'^register/$', 'register'),
    url(r'^login/$', 'org_login'),
    url(r'^logout/$', 'userlogout'),

    # Management
    url(r'^manage/$', 'management_page'),
    url(r'^manage/change-password/$', 'change_password_page'),
    url(r'^manage/new/$', 'add_camp_page'),
    url(r'^manage/edit/$', 'edit_organization_page'),
    url(r'^manage/edit/(?P<org_id>\d+)/(?P<camp_id>\d+)/$', 'edit_camp_page'),
    url(r'^manage/delete/(?P<camp_id>\d+)/$', 'delete_camp_page'),
    url(r'^(?P<org_id>\d+)/$', 'organization_page'),

    # Reverse Publishing
    url(r'^manage/newsgate/$', 'newsgate'),

)
