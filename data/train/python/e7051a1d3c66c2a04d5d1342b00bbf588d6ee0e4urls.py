from django.conf.urls import patterns, include, url
from posts import views
from posts.api import PostResource, UserResource, ManufacturerResource, CarResource
from tastypie.api import Api

post_resource = PostResource()
author_resource = UserResource()

manufacturer_resource = ManufacturerResource()
car_resource = CarResource()

v1_api = Api(api_name='v1')
v1_api.register(post_resource)
v1_api.register(author_resource)

v2_api = Api(api_name='v2')
v2_api.register(manufacturer_resource)
v2_api.register(car_resource)

urlpatterns = patterns('',
    url(r'^$', views.index, name='index'),
    url(r'^api/', include(v1_api.urls)),
    url(r'^api/', include(v2_api.urls)),
)