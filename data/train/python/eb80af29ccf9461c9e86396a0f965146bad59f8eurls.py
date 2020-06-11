from django.conf.urls.defaults import patterns, include, url
from coresql import views

urlpatterns = patterns('',
    url('r^environment(?:/(?P<id>\d+))?/$', views.dispatch_environment_request, name="dispatch-env"),
    url('r^area(?:/(?P<id>\d+))?/$', views.dispatch_area_request, name="dispatch-area"),
    url('r^announcement(?:/(?P<id>\d+))?/$', views.dispatch_announcement_request, name="dispatch-announcement"),
    url('r^annotation(?:/(?P<id>\d+))?/$', views.dispatch_annotation_request, name="dispatch-annotation"),
    url('r^history/(\d+)/$', views.handle_history_request, name="handle-history"),
    url('r^user/(\d+)/$', views.handle_user_request, name="handle-user"),
    
)