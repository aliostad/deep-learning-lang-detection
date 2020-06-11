from django.conf.urls import patterns, url, include
from idb import views, api
import watson

urlpatterns = patterns('',
	# API routes
	url(r'^api/v2/superbowls/(\d+)', api.api_superbowls_id),
	url(r'^api/v2/superbowls', api.api_superbowls),
	url(r'^api/v2/franchises/(\d+)', api.api_franchises_id),
	url(r'^api/v2/franchises', api.api_franchises),
	url(r'^api/v2/mvps/(\d+)', api.api_mvps_id),
	url(r'^api/v2/mvps', api.api_mvps),
	url(r'^api/v2/analytics/(\d+)/results', api.api_analytics_id_results),
	url(r'^api/v2/analytics/(\d+)', api.api_analytics_id),
	url(r'^api/v2/analytics', api.api_analytics),
	url(r'^api/v2', api.api_root),
	url(r'^reset-database', api.api_reset_database),

	# Website routes
	url(r'^superbowls/(\d*)$', views.superbowls),
	url(r'^franchises/(\d*)$', views.franchises),
	url(r'^mvps/(\d*)$', views.mvps),
	url(r'^analytics/(\d*)$', views.analytics),
	url(r'^apinav/$', views.api_navigation),
	url(r'^contact/$', views.contact),
	url(r'^$', views.splash),
	url("^search/", views.search_idb) #for default
	#url(r"^search/(.*)", views.search_idb) #for custom

	# Default views from Watson, should include a view for our output
	#url("^search/", include("watson.urls",namespace="watson")),
)
