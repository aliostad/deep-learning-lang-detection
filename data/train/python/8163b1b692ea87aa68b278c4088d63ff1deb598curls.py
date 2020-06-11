from django.conf.urls.defaults import *
from django.contrib import admin
from lapidus.metrics.resources import ProjectResource, AnnotationResource, MetricDetailResource, MetricResource, ObservationResource
from tastypie.api import Api

admin.autodiscover()

api = Api(api_name='api')
api.register(ProjectResource())
api.register(AnnotationResource())
api.register(MetricDetailResource())
api.register(ObservationResource())

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),
    url(r'^', include('dashboard.urls')),
    url(r'^', include(api.urls)),
)
