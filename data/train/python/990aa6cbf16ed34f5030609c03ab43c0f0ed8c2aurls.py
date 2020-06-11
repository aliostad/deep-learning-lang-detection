from django.conf.urls.defaults import *

urlpatterns = patterns('pytorque.views',
    (r'^$', 'central_dispatch_view'),
    (r'^browse$', 'central_dispatch_view'),
    (r'^monitor$', 'central_dispatch_view'),
    (r'^submit$', 'central_dispatch_view'),
    (r'^stat$', 'central_dispatch_view'),

    (r'^login/$', 'login'),
    (r'^logout/$', 'logout'),

#    (r'^$', 'central_dispatch_view'),
    (r'^user/(?P<username>\w{0,50})/$', 'index'),
    (r'^user/(?P<username>\w{0,50})/browse$', 'browse'),
#    (r'^user/(?P<username>\w{0,50})/monitor', 'monitor'),
#    (r'^user/(?P<username>\w{0,50})/submit', 'submit'),
#    (r'^user/(?P<username>\w{0,50})/stat', 'stat'),
)
  