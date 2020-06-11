from django.conf.urls import patterns, include, url
from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static

from uploadFile.views import upload_file, search_file, my_reports, report_view
from userAccount.views import create_account, auth_view, user_home, logout, manage_user, manage_group, my_groups, \
    manage_reports, change_password


urlpatterns = patterns('',
                       # Examples:
                       # url(r'^$', 'Demo.views.home', name='home'),
                       # url(r'^blog/', include('blog.urls')),
                       url(r'^admin/', include(admin.site.urls)),
                       url(r'^upload/$', upload_file),
                       url(r'^search/$', search_file),
                       url(r'^view_report/(?P<id>[0-9]+)/$', report_view),
                       url(r'^create_account/$', create_account),
                       url(r'^auth/$', auth_view),
                       url(r'^user_home/$', user_home),
                       url(r'^logout/$', logout),
                       url(r'^manage_user/$', manage_user),
                       url(r'^manage_group/$', manage_group),
                       url(r'^manage_reports/$', manage_reports),
                       url(r'^my_reports/$', my_reports),
                       url(r'^my_groups/$', my_groups),
                       url(r'^change_password/$', change_password),
                       ) + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
