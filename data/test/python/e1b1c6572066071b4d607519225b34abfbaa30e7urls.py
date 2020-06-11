from django.conf.urls import patterns, include, url
from django.contrib import admin
from tastypie.api import Api

from ToulouseCommuter import views
from ToulouseCommuter.api import *

admin.autodiscover()

v1_api = Api(api_name='v1')
v1_api.register(AgencyResource())
v1_api.register(CalendarResource())
v1_api.register(CalendarDateResource())
v1_api.register(FrequencyResource())
v1_api.register(RouteResource())
v1_api.register(ShapeResource())
v1_api.register(StopResource())
v1_api.register(StopTimeResource())
v1_api.register(TripResource())

urlpatterns = patterns(
    '',
    url(r'^$', 'ToulouseCommuter.views.index'),
    url(r'^admin/', include(admin.site.urls)),
    (r'^api/', include(v1_api.urls)),
)
