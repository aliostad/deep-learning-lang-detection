from django.conf.urls.defaults import *

urlpatterns = patterns('proxynow5_proj.proxynow5.NAT.views',
                       (r'^$', 'nat_page'),
                       
                       (r'^pf/$', 'natpf_page'),
                       (r'^pf/save/$', 'natpf_save'),
                       (r'^pf/delete/$', 'natpf_delete'),
                       (r'^pf/list/$', 'natpf_list'),
                       
                       (r'^masq/$', 'natmasq_page'),
                       (r'^masq/save/$', 'natmasq_save'),
                       (r'^masq/delete/$', 'natmasq_delete'),
                       (r'^masq/save/location/$', 'natmasq_save_location'),
                       (r'^masq/list/$', 'natmasq_list'),
                       
                       (r'^dnatsnat/$', 'natdnatsnat_page'),
                       (r'^dnatsnat/save/$', 'natdnatsnat_save'),
                       (r'^dnatsnat/delete/$', 'natdnatsnat_delete'),
                       (r'^dnatsnat/list/$', 'natdnatsnat_list'),
)