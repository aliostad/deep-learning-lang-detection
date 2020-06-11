from django.conf.urls import patterns, url
from cascade.apps.api.views import TicketSearchAPI, CartProfileAPI, CartSearchAPI, CustomerProfileAPI, \
    LocationSearchAPI, CartStatusAPI, CartTypeAPI, TicketAPI, LocationAPI, AdminDefaultLocation, TicketStatusAPI, \
    TicketCommentAPI, TicketServiceTypeAPI, FileUploadListAPI, RouteListAPI, CartServiceChargesAPI, CartPartsAPI, \
    FileUploadAPI, ProfileAPI, ReportFileListAPI, HelpRequestAPIView


from django.views.decorators.cache import cache_page
from rest_framework.urlpatterns import format_suffix_patterns



#Note the regex pattern (?:/(?P<pk>\d+)?$ is used to make this optional, added a default view to accommodate.
urlpatterns = patterns('cascade.apps.api.views',

                       url(r'^location/profile/(?P<location_id>[a-zA-Z0-9]+)?$', LocationAPI.as_view(),
                           name='location_api_profile'),
                       url(r'^location/search/$',
                           cache_page(60 * 3)(LocationSearchAPI.as_view()), name='location_api_search'),
                       url(r'^default/location/$', AdminDefaultLocation.as_view(), name='admin_api_location'),
                       url(r'^cart/search/$', cache_page(60 * 3)(CartSearchAPI.as_view()), name='cart_api_search', ),
                       url(r'^cart/profile/(?P<serial_number>[a-zA-Z0-9]+)?$', CartProfileAPI.as_view(),
                           name='cart_api_profile'),
                       url(r'^cart/type/options/$', CartTypeAPI.as_view(), name='cart_type_api'),
                       url(r'^cart/services/charges/$', CartServiceChargesAPI.as_view(),
                           name='cart_service_charge_api'),
                       url(r'cart/parts/options/$', CartPartsAPI.as_view(), name='cart_parts_api'),
                       url(r'^cart/status/options/$', CartStatusAPI.as_view(), name='cart_status_api'),
                       url(r'^customer/profile/(?P<customer_id>[a-zA-Z0-9]+)?$', CustomerProfileAPI.as_view(),
                           name='customer_api_profile'),
                       url(r'^upload/files/', FileUploadAPI.as_view(), name='upload_file_api'),
                       url(r'^files/search/', FileUploadListAPI.as_view(), name='upload_file_list_api'),
                       url(r'^ticket/list/$', TicketSearchAPI.as_view(), name='tickets_api_download'),
                       url(r'^ticket/(?P<ticket_id>[a-zA-Z0-9]+)?$',
                           TicketAPI.as_view(), name='ticket_api'),
                       url(r'^ticket/comment/(?P<ticket_id>[a-zA-Z0-9]+)?$', TicketCommentAPI.as_view(),
                           name='ticket_comment_api'),
                       url(r'^ticket/status/options/$', TicketStatusAPI.as_view(), name='ticket_status_api'),
                       url(r'^ticket/service/options/$', TicketServiceTypeAPI.as_view(),
                           name='ticket_service_type_api'),
                       url(r'^route/search/$', RouteListAPI.as_view(), name='route_search_api'),
                       url(r'^profile/$', ProfileAPI.as_view(), name='profile_api'),
                       url(r'^reports/(?P<report_type>[a-zA-Z0-9]+)?$', ReportFileListAPI.as_view(), name='report_list_api'),
                       url(r'^help/', HelpRequestAPIView.as_view(), name='help_request_api')

                       )

urlpatterns = format_suffix_patterns(urlpatterns)

