from django.conf.urls import patterns, url
from account.views import login_user, logout_user, change_password, register, \
    request_recovery, recover_account, activate_account, request_account_deactivation, deactivate_account, manage_account

urlpatterns = patterns(
    '',
    url(r'^login/$', login_user),
    url(r'^logout/$', logout_user),
    url(r'^register/$', register),
    url(r'^recover/$', request_recovery),
    url(r'^recover/(?P<username>\w+)/(?P<key>[a-z0-9]{64})/$', recover_account),
    url(r'^activate/(?P<username>\w+)/(?P<key>[a-z0-9]{64})/$', activate_account),
    url(r'^manage/$', manage_account),
    url(r'^manage/password/$', change_password),
    url(r'^manage/deactivate/$', request_account_deactivation),
    url(r'^manage/deactivate/(?P<username>\w+)/(?P<key>[a-z0-9]{64})/$', deactivate_account),

)
