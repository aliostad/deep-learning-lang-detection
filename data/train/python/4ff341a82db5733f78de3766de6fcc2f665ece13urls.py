from django.conf.urls.defaults import *

urlpatterns = patterns('proxynow5_proj.proxynow5.WebProxy.views',
                       (r'^wp/save/$', 'wp_save'),
                       
                       (r'^wpprofile/$', 'wpprofile_page'),
                       (r'^wpprofile/save/$', 'wpprofile_save'),
                       (r'^wpprofile/delete/$', 'wpprofile_delete'),
                       (r'^wpprofile/save/enable/$', 'wpprofile_save_enable'),
                       (r'^wpprofile/save/location/$', 'wpprofile_save_location'),
                       (r'^wpprofile/list/$', 'wpprofile_list'),
                       
                       (r'^wpadvance/$', 'wpadvance_save'),
                       (r'^wpadvanceskip/$', 'wpadvanceskip_page'),
                       (r'^wpadvanceskip/save/$', 'wpadvanceskip_save'),
                       (r'^wpadvanceskip/delete/$', 'wpadvanceskip_delete'),
                       
                       (r'^wpadvanceallow/$', 'wpadvanceallow_page'),
                       (r'^wpadvanceallow/save/$', 'wpadvanceallow_save'),
                       (r'^wpadvanceallow/delete/$', 'wpadvanceallow_delete'),
                       (r'^wpadvanceallow/port/save/$', 'wpadvanceallow_saveport'),
                       
                       (r'^nettrusted/$', 'nettrusted_page'),
                       (r'^nettrusted/net/save/$', 'nettrusted_net_save'),
                       (r'^nettrusted/net/delete/$', 'nettrusted_net_delete'),
)