from django.conf.urls import patterns, include, url
from django.contrib import admin
from api import *
from tastypie.api import Api

v1_api = Api(api_name='v1')
v1_api.register(AddressResource())
v1_api.register(PersonResource())
v1_api.register(FormOfLegResource())
v1_api.register(TypeOfSocFormResource())
v1_api.register(SocialFormationResource())
v1_api.register(FiliaResource())
'''
v1_api.register(AdresaResource())


v1_api.register(AdresaResource())
v1_api.register(ArbitrazhnijResource())
v1_api.register(BorzhnikResource())
v1_api.register(KreditorResource())
v1_api.register(VimogiResource())
'''
urlpatterns = patterns('',
    url(r'^api/', include(v1_api.urls)),
    url(r'^admin/', include(admin.site.urls)),
)

