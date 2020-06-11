from django.conf.urls import patterns, include, url
from tastypie.api import Api
from factopy.api import StreamResource, MaterialResource, \
    MaterialStatusResource, ProcessResource


api_v1 = Api(api_name='v1')
api_v1.register(StreamResource())
api_v1.register(MaterialResource())
api_v1.register(MaterialStatusResource())
api_v1.register(ProcessResource())

urlpatterns = patterns('',
                       url(r'^api/', include(api_v1.urls)),
                       url(r'^$', 'factopy.views.index'),
                       )
