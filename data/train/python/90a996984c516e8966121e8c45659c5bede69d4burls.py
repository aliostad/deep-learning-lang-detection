from django.conf.urls import url, patterns, include
from .api import DataSetResource, UserResource, DataItemResource, ExecHistoryResource
from tastypie.api import Api


v1_api = Api(api_name='v1')
v1_api.register(DataSetResource())
v1_api.register(UserResource())
v1_api.register(DataItemResource())
v1_api.register(ExecHistoryResource())


urlpatterns = patterns('alyticsproc.views',
    url(r'^$', 'index', name='index'),
    url(r'^start-processing/$', 'start_processing', name='start_processing'),

    url(r'api/', include(v1_api.urls)),
)