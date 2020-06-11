from tastypie.api import Api
from apps.api.resource import *  

v1_api = Api(api_name='v1')

v1_api.register(UserSignUpResource()) 
v1_api.register(UsersResource()) 
v1_api.register(AllowedUsersResource()) 
v1_api.register(WorkspaceResource()) 
v1_api.register(AppsResource()) 
v1_api.register(WorkSpaceAppsResource()) 
v1_api.register(SectionHasFieldResource()) 
v1_api.register(SectionResource()) 
v1_api.register(FieldResource()) 
v1_api.register(AppHasSectionResource()) 
v1_api.register(AddSectionToApplicationResource()) 
v1_api.register(ShareApplicationResource()) 
