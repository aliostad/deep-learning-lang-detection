from django.conf.urls import *
import blast.feed.views as views
from tastypie.api import Api
from blast.feed.api import v1, v1_1

v1_api = Api(api_name='v1')
v1_api.register(v1.PictureResource())

v1_1_api = Api(api_name='v1.1')
v1_1_api.register(v1_1.PictureResource())

urlpatterns = patterns(
    '',
    url(r'^$', views.feed),
    url(r'^android/$', views.android),
    url(r'^iphone/$', views.iphone),
    url(r'^upload$', views.edit_image),
    url(r'^upload/post$', views.upload),
    url(r'^upload/publish$', views.publish),
    url(r'^api/', include(v1_api.urls)),
    url(r'^api/', include(v1_1_api.urls)),
    url(r'^imageupload/', views.upload_image),
)
