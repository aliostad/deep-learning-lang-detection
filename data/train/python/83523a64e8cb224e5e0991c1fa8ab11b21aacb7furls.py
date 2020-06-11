from django.conf.urls import patterns, url, include
from taxi import views, api
from tastypie.api import Api


v1_api = Api(api_name='v1')
v1_api.register(api.TaxiResource())
v1_api.register(api.CityResource())


urlpatterns = patterns(
    '',
    url(r'^$', views.index, name='index'),
    url(r'^city/(?P<city_id>\d+)/$', views.city, name='city'),
    url(r'^taxi/(?P<taxi_id>\d+)/$', views.taxi, name='taxi'),
    url(r'^app$', views.AppView.as_view(), name='app'),
    url(r'^api/', include(v1_api.urls), name='city_api'),
)
