from django.conf.urls.defaults import *
from api.views import *

urlpatterns = patterns('',
    url(r'^v1/authenticate/$', api_authentication, name='api_authenticate'),
    url(r'^v1/add-card/$', api_add_card, name='api_add_card'),
    url(r'^v1/complete-order/$', api_complete_order, name='api_complete_order'),
    url(r'^v1/create-user/$', api_createuser, name='api_createuser'),
    url(r'^v1/order/(?P<city>\w+)/$', api_order, name='api_order'),
    url(r'^v1/order/(?P<city>\w+)/test/$', api_order_test, name='api_order_test'),
)