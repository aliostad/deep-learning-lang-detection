from django.conf.urls import include, url
from tastypie.api import Api

import views
from resources import *

api_version = 'v1'

v1_api = Api(api_name=api_version)
v1_api.register(UserResource())
v1_api.register(DeviceResource())
v1_api.register(JourneyResource())
v1_api.register(PositionResource())
v1_api.register(LogResource())

urlpatterns = [
    url(r'^api/', include(v1_api.urls)),
    url(r'^api/{}/fleet/((?P<id>[0-9]+|)/)?$'.format(api_version), views.FleetView.as_view()),
    url(r'^api/{}/fleet/(?P<id>[0-9]+)/user/(?P<email>[\w.@+-]+|)/$'.format(api_version),
        views.FleetUserView.as_view()),
    url(r'^api/{}/fleet/(?P<id>[0-9]+)/device/(?P<email>[\w.@+-]+|)/$'.format(api_version),
        views.FleetDeviceView.as_view()),
]
