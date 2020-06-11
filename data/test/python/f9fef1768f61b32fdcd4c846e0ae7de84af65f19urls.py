from django.conf.urls import patterns, url, include

from myquorum_core.views import views, api_views

urlpatterns = patterns('',
	#Front-end views
	url(r'^$', views.index, name='index'),
	url('^event/(?P<event_id>\w+)/$', views.view, name='view'),
	url('^event/(?P<event_id>\w+)/edit/$', views.edit, name='edit'),
	url('^near/$', views.near, name='near'),
	url('^authenticate/$', views.authenticate_view, name='authenticate'),
	url('^login/$', views.login_view, name='login'),
	
	#API views
	url('^api/authenticate/$', api_views.authenticate_api, name='authenticate_api'),
	url('^api/events/$', api_views.events_api, name='events_api'),
	url('^api/events/(?P<event_id>\w+)/$', api_views.single_event_api, name='single_event_api'),
	url('^api/attendants/$', api_views.attendants_api, name='attendants_api'),
)
