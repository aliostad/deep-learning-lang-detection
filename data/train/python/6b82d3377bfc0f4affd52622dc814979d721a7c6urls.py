from django.conf.urls.defaults import *

urlpatterns = patterns('proxynow5_proj.proxynow5.Application_Control.views',
                       (r'^appctrl/save/$', 'appctrl_save'),
                       (r'^appctrlrule/$', 'appctrlrule_page'),
                       (r'^appctrlrule/save/$', 'appctrlrule_save'),
                       (r'^appctrlrule/delete/$', 'appctrlrule_delete'),
                       (r'^appctrlrule/save/enable/$', 'appctrlrule_save_enable'),
                       (r'^appctrlrule/save/location/$', 'appctrlrule_save_location'),
                       (r'^appctrlrule/list/$', 'appctrlrule_list'),
                       (r'^appctrlapplist/list/panel/$', 'appctrlapplist_list_panel'),
                       (r'^appctrlapplist/list/select/$', 'appctrlapplist_list_select'),
)