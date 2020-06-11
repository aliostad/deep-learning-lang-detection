from django.conf.urls import patterns, include, url

from django.conf.urls.defaults import *
from django.views.generic.base import TemplateView
from django.contrib import admin
from firstest.views import *
admin.autodiscover()

urlpatterns = patterns('',
    url(r'^$', TemplateView.as_view(template_name='index.html'),name='index'),
    url(r'^manage/$', manage_json, name='manage'),
    url(r'^manage/json/(?P<model_name>\w+)/$', manage_json, name='manage_json'),
    url(r'^manage/add/(?P<model_name>\w+)/$', manage_add, name='manage_json'),
    url(r'^manage/save/(?P<model_name>\w+)/(?P<field_name>\w+)/(?P<field_type>\w+)/(?P<pk_model>\d+)/$', manage_add),
    url(r'^admin/', include(admin.site.urls)),
)
