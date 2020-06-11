from django.conf.urls import url

from . import views
from backend import cal

urlpatterns = [
	url(r'^(?P<instance_id>[0-9]+)/$', views.detail, name='detail'),
	url(r'^add/', views.add, name='add'),
	url(r'^manageCreator/', views.manageCreator, name='manageCreator'),
	url(r'^manageInvitee/', views.manageInvitee, name='manageInvitee'),
	url(r'^manageNotification/', views.manageNotification, name='manageNotification'),
	url(r'^register/$', views.register, name='register'),
	url(r'^login/$', views.user_login, name='login'),
	url(r'^logout/$', views.user_logout, name='logout'),
	url(r'^auth/$', cal.auth, name='auth'),
    url(r'^$', views.index, name='index'),
    url(r'^autocomplete_user/$', views.autocomplete_user, name='autocomplete_user'),
    url(r'^confirm/(?P<activation_key>\w+)/', views.register_confirm, name='confirm_email'),
]