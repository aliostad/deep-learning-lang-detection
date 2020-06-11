from django.conf.urls.defaults import *

urlpatterns = patterns('proxynow5_proj.proxynow5.Network.views',
                       (r'^netint/$', 'netint_page'),
                       (r'^netint/save/$', 'netint_save'),
                       (r'^netint/delete/$', 'netint_delete'),
                       (r'^netint/list/$', 'netint_list'),
                       
                       (r'^netdhcp/$', 'netdhcp_page'),
                       (r'^netdhcp/save/$', 'netdhcp_save'),
                       (r'^netdhcp/delete/$', 'netdhcp_delete'),
                       (r'^netdhcp/list/$', 'netdhcp_list'),
                       
                       (r'^netdns/$', 'netdns_page'),
                       (r'^netdns/allownet/save/$', 'netdns_allownet_save'),
                       (r'^netdns/allownet/delete/$', 'netdns_allownet_delete'),
                       (r'^netdns/relay/save/$', 'netdns_relay_save'),
                       (r'^netdns/relay/delete/$', 'netdns_relay_delete'),
                       (r'^netdns/relay/defnet/save/$', 'netdns_relay_defnet_save'),
                       
                       (r'^netlb/loadbl/$', 'get_list_balance'),
                       (r'^netlb/savelist/$', 'netlb_savelist'),
                       (r'^togglenetlb/$', 'netlb_toggle'),
                       
                       (r'^netroute/$', 'netroute_page'),
                       (r'^netroute/save/$', 'netroute_save'),
                       (r'^netroute/delete/$', 'netroute_delete'),
                       (r'^netroute/list/$', 'netroute_list'),
                       (r'^netroute/gateway/defnet/save/$', 'netroute_gateway_defnet_save'),
)