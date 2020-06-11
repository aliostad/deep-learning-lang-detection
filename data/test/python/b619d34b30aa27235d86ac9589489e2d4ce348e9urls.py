from django.conf.urls import patterns, url

from schemes.views import index, new_scheme, detail, manage_schemes, delete, modify
from messaging.views import create_application

urlpatterns = patterns('',
	url(r'^$', index, name='index'),
	url(r'^new/', new_scheme, name='new'),
	url(r'^manage/', manage_schemes, name='manage_schemes'),
	url(r'^(?P<scheme_id>\d+)/$', detail, name='detail'),
	url(r'^(?P<scheme_id>\d+)/delete/', delete, name='delete'),
	url(r'^(?P<scheme_id>\d+)/modify/', modify, name='modify'),
	url(r'^(?P<scheme_id>\d+)/join/$', send_application, name='create_application'),
)