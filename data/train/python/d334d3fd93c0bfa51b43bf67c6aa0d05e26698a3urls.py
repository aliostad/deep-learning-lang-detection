from django.conf.urls import url, include
from django.contrib import admin

from . import views
from backend import cal

urlpatterns = [
	url(r'^$', views.index, name='index'),
	url(r'^add/', views.add, name='add'),
	url(r'^admin/', include(admin.site.urls)),
	url(r'^auth/$', cal.auth, name='auth'),
	url(r'^changePassword/', views.changePassword, name='changePassword'),
	url(r'^confirm/(?P<activation_key>\w+)', views.register_confirm, name='confirm_email'),
	url(r'^forgotPassword/(?P<login_key>\w*)', views.forgotPassword, name='forgotPassword'),
	url(r'^login/$', views.user_login, name='login'),
	url(r'^loginEvent/$', views.user_loginEvent, name='loginEvent'),
	url(r'^logout/$', views.user_logout, name='logout'),
	url(r'^manageCreator/', views.manageCreator, name='manageCreator'),
	url(r'^manageInvitee/', views.manageInvitee, name='manageInvitee'),
	url(r'^manageMessage/', views.manageMessage, name='manageMessage'),
	url(r'^manageNotification/', views.manageNotification, name='manageNotification'),
	url(r'^register/$', views.register, name='register'),
	url(r'^registerEvent/$', views.registerEvent, name='registerEvent'),
	url(r'^userPage/$', views.userPage, name='userPage'),
	url(r'^resetGAuth/$', views.resetGAuth, name='resetGAuth'),
	url(r'^(?P<eventID>\w+)/', views.detail, name='detail'),
]