from django.conf.urls import patterns, url
from administration.views import *

urlpatterns = patterns ('',
    #Administration Main Page
    url(r'^$', main_page),

    #Administration Forbidden Page
    url(r'^forbidden/', access_forbidden),
    url(r'^redirect/', redirect),

    url(r'^users/', manage_users),
    url(r'^backups/', manage_backups),
    url(r'^warehouses/', manage_warehouses),
    url(r'^categories/', manage_categories),
    url(r'^box_names/', manage_box_names),
    url(r'^reset_password/(?P<reset_code>\w+)/$', reset_password),
    url(r'^send_reset/', send_reset),
    url(r'^settings/', user_settings)
)
