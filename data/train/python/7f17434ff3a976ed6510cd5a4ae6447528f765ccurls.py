# urls.py
# =======
from django.conf.urls.defaults import *
from tastypie.api import Api
from api import StatusUpdateResource, SeverityResource, ServiceResource, ServiceOutageResource, StatusResource

v1_api = Api(api_name='v1')
v1_api.register(StatusUpdateResource())
v1_api.register(SeverityResource())
v1_api.register(ServiceResource())
v1_api.register(ServiceOutageResource())
v1_api.register(StatusResource())

urlpatterns = patterns('',
    # The normal jazz here then...
    (r'', include(v1_api.urls)),
)
