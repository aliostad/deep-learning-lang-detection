from django.conf.urls import patterns, include
from dashboard.urls import url

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('dashboard',
    url(r'^success/$', 'views.index', name='index'),
    url(r'^authorize_manage/', include('dashboard.authorize_manage.urls')),
    url(r'^control_manage/', include('dashboard.control_manage.urls')),
    url(r'^instance_manage/', include('dashboard.instance_manage.urls')),
    url(r'^image_template_manage/', include('dashboard.image_template_manage.urls')),
    url(r'^hard_template_manage/', include('dashboard.hard_template_manage.urls')),
    url(r'^user_manage/', include('dashboard.user_manage.urls')),
    url(r'^project_manage/', include('dashboard.project_manage.urls')),
    url(r'^node_manage/', include('dashboard.node_manage.urls')),
    url(r'^software_manage/', include('dashboard.software_manage.urls')),
    url(r'^volume_manage/', include('dashboard.volume_manage.urls')),
    url(r'^log_manage/', include('dashboard.log_manage.urls')),
    url(r'^monitor_manage/', include('dashboard.monitor_manage.urls')),
    url(r'^securitygroup_manage/', include('dashboard.securitygroup_manage.urls')),
    url(r'^notice_manage/', include('dashboard.notice_manage.urls')),
    url(r'^static_resource_manage/', include('dashboard.static_resource_manage.urls')),
    url(r'^thresholds_manage/', include('dashboard.thresholds_manage.urls')),
    url(r'^virtual_address_manage/', include('dashboard.virtual_address_manage.urls')),
    url(r'^virtual_network_manage/', include('dashboard.virtual_network_manage.urls')),
    url(r'^virtual_network_topology/', include('dashboard.virtual_network_topology.urls')),
    url(r'^virtual_router_manage/', include('dashboard.virtual_router_manage.urls')),
    url(r'^virtual_keypairs_manage/', include('dashboard.virtual_keypairs_manage.urls')),
    url(r'^role_manage/', include('dashboard.role_manage.urls')),
    url(r'^prepare_manage/', include('dashboard.prepare_manage.urls')),
    url(r'^check_manage/', include('dashboard.check_manage.urls')),
    #url(r'^authorize/',include('dashboard.authorize.urls')),
    #url(r'^user_manage/',include('dashboard.user_manage.urls')),
    #url(r'^$','dashboard.login.views.splash',name='splash'),
    #url(r'^auth/',include('openstack_auth.urls')),
    # Examples:
    # url(r'^$', 'creeper.views.home', name='home'),
    # url(r'^creeper/', include('creeper.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
)
