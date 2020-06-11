# -*- coding: utf-8 -*-

from django.conf.urls.defaults import *
from django.conf import settings

# import views
# Empty urlpatterns is needed due dynamic import in ROOT_URLCONF
#urlpatterns = patterns('',)

from location.apitastypie import EntityResource
from location.apitastypie import UserResource

from tastypie.api import Api

v1_api = Api(api_name='v1')
#v1_api = Api()
v1_api.register(EntityResource())
v1_api.register(UserResource())

#entity_resource = EntityResource()

urlpatterns = patterns('',
#    (r'^apitastypie/', include(entity_resource.urls)),
    (r'^api/', include(v1_api.urls)),
)
