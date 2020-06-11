from django.conf.urls import patterns, include
from tastypie.api import Api

from politici.v2.api import ProfessionResource, PoliticianResource, ResourceResource,\
EducationLevelResource, InstitutionChargeResource, PoliticalChargeResource, OrganizationChargeResource, InstitutionResource, \
DeputiesResource, ChargeTypeResource

v2_api = Api(api_name='v2')
v2_api.register(PoliticianResource())
v2_api.register(ProfessionResource())
v2_api.register(EducationLevelResource())
v2_api.register(ResourceResource())
v2_api.register(InstitutionResource())
v2_api.register(InstitutionChargeResource())
v2_api.register(PoliticalChargeResource())
v2_api.register(OrganizationChargeResource())
v2_api.register(DeputiesResource())
v2_api.register(ChargeTypeResource())

urlpatterns = patterns('',
    (r'^', include(v2_api.urls)),
)
