from django.conf.urls.defaults import patterns, include, url


urlpatterns = patterns('',

	url(r'^$', 'glue.api.index', name='glue_api_index'),

	url(r'^api/manage/(?P<model_name>[a-zA-Z_]+)/$', 'glue.api.manage_objects', name='glue_api_manage_objects'),
	url(r'^api/manage/(?P<model_name>[a-zA-Z_]+)/(?P<pk>\d+)$', 'glue.api.manage_single_object', name='glue_api_manage_single_object'),

	url(r'^api/test/$', 'glue.api.test', name='glue_api_test'), # get list, post single page

	url(r'^api/page/$', 'glue.api.pages', name='glue_api_pages'), # get list, post single page
	url(r'^api/page/(?P<page_id>\d+)/$', 'glue.api.page', name='glue_api_page'), 
	url(r'^api/page/(?P<page_slug>[a-zA-Z\d\-]+)/(?P<page_language>[a-zA-Z]{2})/$', 'glue.api.page_by_slug', name='glue_api_page_by_slug'),

	url(r'^api/pin/$', 'glue.api.pins', name='glue_api_pins'), # get list, post single page
	url(r'^api/pin/(?P<pin_id>\d+)/$', 'glue.api.pin', name='glue_api_pin'), 
	url(r'^api/pin/(?P<pin_slug>[a-zA-Z\d\-]+)/(?P<pin_language>[a-zA-Z]{2})/$', 'glue.api.pin_by_slug', name='glue_api_pin_by_slug'), 
	url(r'^api/pin/(?P<pin_id>\d+)/publish/$', 'glue.api.publish_pin', name='glue_api_publish_pin'), 
	url(r'^api/pin/upload/$', 'glue.api.pin_upload', name='glue_api_pin_upload'), 
)
