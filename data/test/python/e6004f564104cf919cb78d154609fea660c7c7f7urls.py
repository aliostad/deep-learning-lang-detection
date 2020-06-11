from django.conf.urls import patterns, url, include
from tastypie.api import Api

from api import VendorResource, BillingItemsResource, BillResource, CompanyCategoryResource, ContactInfoResource

vendor_api = Api('vendor_api')
vendor_api.register(VendorResource())
vendor_api.register(BillingItemsResource())
vendor_api.register(BillResource())
vendor_api.register(CompanyCategoryResource())
vendor_api.register(ContactInfoResource())

urlpatterns = patterns('',

                         url(r'^api/', include(vendor_api.urls))

                       )