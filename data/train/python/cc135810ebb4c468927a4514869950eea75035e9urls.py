from django.conf.urls import patterns, url
from SampleISP import views

# url patterns for SampleISP application-wide
urlpatterns = patterns('SampleISP.views',
    url(r'^(?i)SampleISP/$', 'index', name='index'),

    url(r'^(?i)SampleISP/customers/$', 'customer_list', name='customer_list'),
    url(r'^(?i)SampleISP/customers/(?P<customer_id>\d+)/$', 'customer_detail', name='customer_detail'),

    url(r'^(?i)SampleISP/switches/$', 'switch_list', name='switch_list'),

    #url(r'^(?i)SampleISP/routers/$', 'router_list', name='router_list'),
    url(r'^(?i)SampleISP/routers/$', views.RouterListView.as_view(), name='router_list'),
    url(r'^(?i)SampleISP/routers/(?P<pk>\d+)/$', views.RouterDetailView.as_view(), name='router_detail'),
    url(r'^(?i)SampleISP/routers/(\w+)/$', views.RouterListView.as_view(), name='router_filtered_list'),

    url(r'^(?i)SampleISP/routerports/$', views.RouterPortListView.as_view(), name='routerport_list'),
    url(r'^(?i)SampleISP/routerports/manage/$', 'manage_routerport', name='manage_routerport'),
    url(r'^(?i)SampleISP/routerports/new_manage/$', views.RouterPortManageView.as_view(), name='new_manage_routerport'),
    url(r'^(?i)SampleISP/routerports/manage/(\w+)/$', 'manage_routerport', name='manage_filtered_routerport'),
    url(r'^(?i)SampleISP/routerports/new_manage/(\w+)/$', views.RouterPortManageView.as_view(), name='new_manage_filtered_routerport'),
    url(r'^(?i)SampleISP/routerports/add/$', 'add_routerport', name='add_routerport'),
    url(r'^(?i)SampleISP/routerports/(?P<pk>\d+)/$', views.RouterPortDetailView.as_view(), name='routerport_detail'),
    url(r'^(?i)SampleISP/ras/$', views.RASListView.as_view(), name='ras_list'),
    url(r'^(?i)SampleISP/ras/(?P<pk>\d+)/$', views.RasManageView.as_view(), name='manage_ras'),
)

