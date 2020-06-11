from django.conf.urls.defaults import patterns, include, url
from django.contrib import admin
from django.conf import settings
admin.autodiscover()

from kit.issues.views import HomePage, ManageProject, PUCreate, PUUpdate

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'kit.views.home', name='home'),
    # url(r'^kit/', include('kit.foo.urls')),

    url(r'^$', HomePage.as_view(), name='projects_list'),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^user/login/', 'django.contrib.auth.views.login'),
    url(r'^user/logout/', 'django.contrib.auth.views.logout', dict(next_page='/')),

    # these would break the previous regs
    url(r'^(?P<project>.+)/issues/', include('kit.issues.urls')),
    url(r'^(?P<project>.+)/activity/', include('kit.activity.urls')),
    url(r'^(?P<project>.+)/manage/$', ManageProject.as_view(), name='project_manage'),
    url(r'^(?P<project>.+)/manage/add/$', PUCreate.as_view(), name='project_manage_add'),
    url(r'^(?P<project>.+)/manage/edit/(?P<pk>\d+)/$', PUUpdate.as_view(), name='project_manage_edit'),


)
