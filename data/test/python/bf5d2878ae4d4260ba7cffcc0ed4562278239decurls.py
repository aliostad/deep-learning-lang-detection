from django.conf.urls import patterns, include, url
from django.contrib import admin
from tastypie.api import Api
from progress.apps.food import api


admin.autodiscover()

v1_api = Api(api_name='1.0')
v1_api.register(api.DayResource())
v1_api.register(api.MealResource())


urlpatterns = patterns('',
    url(r'api/',
        include(v1_api.urls)),
    url(r'^food/',
        include('progress.apps.food.urls',
        namespace='food')),
    url(r'^$',
        'progress.apps.home.views.home',
        name='home'),
    url(r'^admin/',
        include(admin.site.urls)),
)
