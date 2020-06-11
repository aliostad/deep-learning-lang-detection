from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    url(r'^/$', 'controller.basic.views.home', name='home'),
    url(r'^/get_port/(?P<port_id>\d+)$', 'controller.basic.views.get_port', name='get_port'),
    url(r'^/get_port_list/(?P<controller_id>\d+)$', 'controller.basic.views.get_port_list', name='get_port_list'),
    url(r'^/get_controller_list/$', 'controller.basic.views.get_controller_list', name='get_controller_list'),

    url(r'^/set_port/(?P<port_id>\d+)/(?P<high>\d+)/(?P<low>\d+)$', 'controller.basic.views.set_port', name='set_port'),

    url(r'^/add_controller/(?P<description>[\w\s]+)/(?P<i2c_bus>\d+)/(?P<i2c_address>\d+)/(?P<frequency>\d+)$', 'controller.basic.views.add_controller', name='add_controller'),
    url(r'^/add_port/(?P<controller_id>\d+)/(?P<port>\d+)/(?P<high>\d+)/(?P<low>\d+)$', 'controller.basic.views.add_port', name='add_port'),
    url(r'^/add_port_dialog$', 'controller.basic.views.add_port_dialog', name='add_port_dialog'),

    url(r'^/remove_controller/(?P<controller_id>\d+)$', 'controller.basic.views.remove_controller', name='remove_controller'),
    url(r'^/remove_port/(?P<port_id>\d+)$', 'controller.basic.views.remove_port', name='remove_port'),

    # url(r'^controller/', include('controller.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
)
