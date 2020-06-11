# django imports
from django.conf.urls.defaults import *

# tastypie imports
from tastypie.api import Api

# lfs_rest imports
from lfs_rest.api import AddressResource
from lfs_rest.api import CategoryResource
from lfs_rest.api import CustomerResource
from lfs_rest.api import OrderResource
from lfs_rest.api import OrderItemResource
from lfs_rest.api import ProductResource

v1_api = Api(api_name='api')
v1_api.register(AddressResource())
v1_api.register(ProductResource())
v1_api.register(CategoryResource())
v1_api.register(CustomerResource())
v1_api.register(OrderResource())
v1_api.register(OrderItemResource())

urlpatterns = patterns('',
    (r'', include(v1_api.urls)),
)
