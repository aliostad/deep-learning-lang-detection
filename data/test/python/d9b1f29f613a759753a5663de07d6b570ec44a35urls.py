# =============================================================================
#  Boston Scientific Confidential
#  Copyright 2008-2010 by Boston Scientific or its affiliates. 
#  All rights reserved.
#
#    $Archive:   CRM:eid=424884:/APM/System/dvt/Tools/fortytwo/sandbox/dolphace/urls.py $
#   $Revision:   11779/2 $
#     $Author:   randy kleinman; g043746 $
#    $Modtime:   2012-09-25T14:47:46-0500 $
# =============================================================================
__version__ = "$Revision:   11779/2 $"

from django.conf.urls.defaults import *
from views import *

urlpatterns = patterns('',
    url(r'results/$',                    handleNotifyMessage,           name="regression_notify_url"),
    url(r'controller/list$',             ControllerListView.as_view(),  name="controller_config_list"),
    url(r'controller/mode/choices',      getControllerModeChoices_ajax, name="controller_mode_choices_ajax"),
    url(r'controller/mode/update',       updateControllerMode_ajax,     name="controller_mode_update_ajax"),
    url(r'controller/mode/$',            getControllerInfo,             name="controller_mode_ajax"),
    url(r'cluster',                      getStationInfo_ajax,           name="regression_station_ajax"),
    url(r'queue',                        getWorkorderQueue_ajax,        name="regression_workorder_queue_ajax"),
    url(r'stationinfo/(?P<station>.*)$', getRawStationProfile_ajax,     name="test_station_info_raw_ajax"),    
    url(r'controller/selftest$',         requestControllerSelfTest,     name="controller_self_test_ajax"),
)
