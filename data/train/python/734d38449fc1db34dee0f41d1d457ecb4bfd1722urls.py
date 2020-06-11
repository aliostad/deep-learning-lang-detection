from django.conf.urls import patterns, url
from django.contrib.auth.decorators import permission_required
from views import BrokerListView, BrokerDetailView, BrokerServiceNewView

urlpatterns = patterns('broker.views',
                       url(r'^$', permission_required('request.user.is_staff')(BrokerListView.as_view()),
                           name='broker_list'),
                       url(r'^(?P<slug>[\w\._-]+)/new/$',
                           permission_required('request.user.is_staff')(BrokerServiceNewView.as_view()),
                           name='broker_service_new'),
                       url(r'^(?P<pk>\d+)/',
                           permission_required('request.user.is_staff')(BrokerDetailView.as_view()),
                           name='broker_detail'),
                       )
