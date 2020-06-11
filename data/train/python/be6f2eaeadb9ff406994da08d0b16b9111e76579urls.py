from django.conf.urls import patterns, include, url
from django.contrib import admin
from django.views.generic import TemplateView
from tastypie.api import Api
from miescuela.api import *

v1_api = Api(api_name='v1')
v1_api.register(ResultadoGlobalResource())
v1_api.register(EscuelaResource())
v1_api.register(LocalidadResource())


admin.autodiscover()

urlpatterns = patterns(
    '',
#    url(r'^$', TemplateView.as_view(template_name="index.html"), name='base_index'),
	url(r'^api/', include(v1_api.urls)),
    url(r'^admin/', include(admin.site.urls)),
)
