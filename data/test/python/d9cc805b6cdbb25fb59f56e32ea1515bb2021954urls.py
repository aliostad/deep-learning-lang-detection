from django.conf.urls import patterns, url

from accounts import views
from accounts.views import Manage, Forgot

urlpatterns = patterns('',
    # account sign in
    url(r'^$', views.signin, name='signin'),
    # account registration
    url(r'^register/$', views.register, name='register'),
    # account sign in
    url(r'^signin/$', views.signin, name='signin'),
    # account sign out
    url(r'^signout/$', views.signout, name='signout'),
    # account management
    url(r'^manage/$', Manage.as_view(), name='manage'),
    # forgot account details
    url(r'^forgot/$', Forgot.as_view(), name='forgot'),
)