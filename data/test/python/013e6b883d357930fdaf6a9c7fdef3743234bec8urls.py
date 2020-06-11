from django.conf.urls import patterns, include
from django.contrib import admin


urlpatterns = patterns('main.views',
    (r'^admin/', include(admin.site.urls)),

    (r'^accounts/login/$', 'login'),
    (r'^accounts/register/$', 'register'),
    (r'^accounts/logout/$', 'logout'),

    (r'^$', 'repository'),
    (r'^repository/$', 'repository'),
    (r'^repository/addfile/$', 'add_file'),
    (r'^repository/delete/(?P<filename>\S+)/$', 'del_file'),
    (r'^repository/download/(?P<filename>\S+)/$', 'download_file'),
)
