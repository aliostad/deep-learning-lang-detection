from django.conf.urls import url
from analytics import api_views


urlpatterns = [
    url(r'^api/heartbeat/', api_views.heartbeat),
    url(r'^api/species/$', api_views.get_species_list),
    url(r'^api/magnifications/$', api_views.get_magnification_list),
    url(r'^api/development-stages/$', api_views.get_development_stage_list),
    url(r'^api/probes/$', api_views.ProbeList.as_view()),
    url(r'^api/images/$', api_views.ImageList.as_view()),
    url(r'^api/images/(?P<pk>[0-9]+)/$', api_views.ImageDetail.as_view()),
    url(r'^api/images-jpeg/(?P<pk>[0-9]+)/$', api_views.get_image_jpeg, name='images-jpeg'),
    url(r'^api/subregions/$', api_views.SubregionList.as_view()),
    url(r'^api/subregions/(?P<pk>[0-9]+)/$', api_views.SubregionDetail.as_view()),
    url(r'^api/image-sets/$', api_views.ImageSetList.as_view()),
    url(r'^api/image-sets/(?P<pk>[0-9]+)/$', api_views.ImageSetDetail.as_view()),
    url(r'^api/anatomy-probe-map/$', api_views.AnatomyProbeMapList.as_view()),
    url(r'^api/train-model/$', api_views.TrainedModelCreate.as_view()),
    url(r'^api/train-model/(?P<pk>[0-9]+)/$', api_views.TrainedModelDetail.as_view()),
    url(r'^api/classify/$', api_views.ClassifySubRegion.as_view())
]
