

from django.conf.urls import patterns, url
from .controller.authentication_view import signin, signout, selenium_login_helper
from .controller.manage_users_view import manage_users

urlpatterns = patterns('',
                       url(r'^login/', signin, name='login'),
                       url(r'^logout/', signout, name='logout'),
                       url(r'^manage-users/', manage_users, name='manage_users'),
                       url(r'^selenium-login/', selenium_login_helper, name='selenium_login_helper'),
                       )
