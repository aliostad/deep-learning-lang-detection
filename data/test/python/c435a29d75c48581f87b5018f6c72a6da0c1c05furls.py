from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

from tastypie.api import Api

from rivers import views, api

v1_api = Api(api_name='v1')
v1_api.register(api.UserResource())
v1_api.register(api.RiverResource())
v1_api.register(api.GaugeResource())
v1_api.register(api.SimpleGaugeResource())
v1_api.register(api.MarkerTypeResource())
v1_api.register(api.MarkerResource())
v1_api.register(api.RapidResource())
v1_api.register(api.RunResource())

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'rivers.views.home', name='home'),
    # url(r'^rivers/', include('rivers.foo.urls')),

    # admin documentation:
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    # admin:
    url(r'^admin/', include(admin.site.urls)),

    # tastypie RESTfull api
    url(r'^api/', include(v1_api.urls)),

    url(r'^$', views.index, name='index'),
    url(r'^levels/$', views.levels, name='levels'),
    url(r'^tools', views.tools, name='tools'),
    url(r'^login/$', views.login_view, name='login'),
    url(r'^logout/$', views.logout_view, name='logout'),
)
