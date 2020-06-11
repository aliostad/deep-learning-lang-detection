from django.conf.urls.defaults import *
#from django.views.generic.simple import redirect_to
from django.conf import settings

from loginurl.views import cleanup, login

urlpatterns = patterns('apps.reminder.views',
    (r'^latest_newsletter/$', 'latest_newsletter'),

    (r'^unsubscribe/$', 'unsubscribe'),
    (r'^overview/$', 'overview'),
    (r'^manage/(?P<year>[0-9]+)/(?P<month>[0-9]+)/(?P<day>[0-9]+)/(?P<hour>[0-9]+)/(?P<minute>[0-9]+)/$', 'manage'),
    (r'^manage/(?P<year>[0-9]+)/(?P<month>[0-9]+)/(?P<day>[0-9]+)/(?P<hour>[0-9]+)/(?P<minute>[0-9]+)/(?P<send>.+)/$', 'manage'),
    (r'^preview/(?P<year>[0-9]+)/(?P<month>[0-9]+)/(?P<day>[0-9]+)/(?P<hour>[0-9]+)/(?P<minute>[0-9]+)/$', 'preview'),
)
