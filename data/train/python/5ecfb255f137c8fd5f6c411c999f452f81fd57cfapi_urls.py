from api import *
from tastypie.api import Api

v1_api = Api(api_name="v1")#1.0 Architecture
v1_api.register(UserProfileResource())
v1_api.register(InteractionResource())
v1_api.register(ContactRelationshipResource())
v1_api.register(CompanyResource())
v1_api.register(PlaceResource())
v1_api.register(CompanyAddressResource())
v1_api.register(CompanyWebsiteResource())
v1_api.register(ContactResource())
v1_api.register(ContactEmailResource())
v1_api.register(CompanySocialResource())
v1_api.register(CompanyAreaResource())
v1_api.register(ContactPhoneResource())
v1_api.register(ContactSocialResource())
v1_api.register(RelationshipResource())

