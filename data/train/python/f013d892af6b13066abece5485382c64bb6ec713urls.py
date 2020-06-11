from django.conf.urls import include, url
from django.contrib import admin

from tastypie.api import Api
from core.api import CategoryResource, UserResource, VendorResource, VendorFieldResource, UserMemberResource, FieldsResource

v1_api = Api(api_name='v1')
v1_api.register(UserResource())
v1_api.register(CategoryResource())
v1_api.register(VendorResource())
v1_api.register(VendorFieldResource())
v1_api.register(UserMemberResource())
v1_api.register(FieldsResource())
# category_resource = CategoryResource()

urlpatterns = [
    url(r'^admin/', include(admin.site.urls)),
    url(r'^api/', include(v1_api.urls)),
#     url(r'^api/', include(category_resource.urls)),
]
