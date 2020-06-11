# -*- coding: utf-8 -*-
from django.conf.urls import *
from rest_framework.urlpatterns import format_suffix_patterns
import api


urlpatterns = patterns('apps.vehicle.views',

       url(r'^(?P<year>\d+)/(?P<make>[-\w]+)/(?P<model>[-\w]+)/(?P<hex_id>[-\w]+)$', 'profile', name='vehicle-profile'),

       url(r'^new/$', 'new', name='vehicle-new'),

       url(r'moderators/approve/$', 'approve', name='vehicle-approve'),

)


# APIs
urlpatterns += patterns('',
       # car
       url(r'^api/cars(/(?P<id>\d+))?$',   api.CarList.as_view(),    name='car-api'),

       # image
       url(r'^api/image$',   api.ImageDetail.as_view(),    name='image-detail-api'),

       # model lookup
       url(r'^api/makes$',                                                                              api.MakeList.as_view(), name='make-list-api'),
       url(r'^api/models$',                                                                             api.ModelDetail.as_view(),   name='model-detail-api'),
       url(r'^api/models/(?P<make>[-\w]+)/(?P<model>[-\w]+)/(?P<year>\d+)(/(?P<trim>[-\w]+))?$',        api.ModelDetail.as_view(),   name='model-detail-api'),
       url(r'^api/models/(?P<make>[-\w]+)(/(?P<year>\d+))?$',                                           api.ModelList.as_view(),     name='model-list-api'),
       url(r'^api/trims/(?P<make>[-\w]+)/(?P<model>[-\w]+)(/(?P<year>\d+))?$',                          api.TrimList.as_view(), name='trim-list-api'),
       url(r'^api/years(/(?P<make>[-\w]+))?(/(?P<model>[-\w]+))?(/(?P<trim>[-\w]+))?$',                 api.YearList.as_view(), name='year-list-api'),

       # color
       url(r'^api/colors$', api.ColorList.as_view(), name='color-list-api'),

       # price
       url(r'^api/price(/(?P<make>[-\w]+))?(/(?P<model>[-\w]+))?(/(?P<trim>[-\w]+))?$',   api.PriceRange.as_view(), name='price-range-api'),

       # mileage
       url(r'^api/mileage(/(?P<make>[-\w]+))?(/(?P<model>[-\w]+))?(/(?P<trim>[-\w]+))?$', api.MileageRange.as_view(), name='mileage-list-api'),

)

urlpatterns = format_suffix_patterns(urlpatterns)

