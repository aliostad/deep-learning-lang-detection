from django.conf.urls.defaults import *
from dashboard.main.appfirst_api import *

urlpatterns = patterns('dashboard.main.views',
    url(r'^$', 'index', name="mainpage"),
    
    (r'^dashboard/$', 'index'),
    (r'^dashboard$', 'index'),
    
    (r'^api/application/metrics/list/$', 'api_application_metrics_list'),
    (r'^api/application/metrics/data/$', 'api_application_metrics_data'),
    (r'^api/business/metrics/list/$', 'api_business_metrics_list'),
    (r'^api/business/metrics/data/$', 'api_business_metrics_data'),
    (r'^api/servers/data/$', 'api_servers'),
    (r'^api/server/tags/data/$', 'api_server_tags'),
    (r'^api/system/data/$', 'api_system'),
)
