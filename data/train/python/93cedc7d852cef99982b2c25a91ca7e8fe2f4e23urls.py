from django.conf.urls import patterns, include, url
from tastypie.api import Api
from broab.api.resources import *


v1_api = Api(api_name='v1')
v1_api.register(BlockResource())
v1_api.register(SegmentResource())
v1_api.register(RecordingChannelGroupResource())
v1_api.register(RecordingChannelResource())
v1_api.register(UnitResource())
v1_api.register(AnalogSignalResource())
v1_api.register(IrregularlySampledSignalResource())
v1_api.register(SpikeTrainResource())
v1_api.register(SpikeTrainFullResource())
v1_api.register(EventResource())
v1_api.register(EventLabelResource())

urlpatterns = patterns('',
    # api urls
    url(r'^api/', include(v1_api.urls)),
)
