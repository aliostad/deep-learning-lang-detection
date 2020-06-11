from django.conf.urls import patterns, url
from django.core.urlresolvers import reverse_lazy
from django.views.generic import RedirectView

from play_api import views

urlpatterns = patterns('',


    url(r'^api/registration/$', views.api_registration ,name='api_registration'),

    url(r'^api/facebook_auth/$', views.facebook_auth ,name='facebook_auth'),


    url(r'^api/v1/login/$', views.api_v1_login ,name='api_login'),
    url(r'^api/v1/home/$', views.api_v1_home ,name='api_home'),
    url(r'^api/v1/logout/$', views.api_v1_logout ,name='api_logout'),
    url(r'^api/v1/my_events/$', views.api_v1_my_events ,name='api_my_events'),
    url(r'^api/v1/events/$', views.api_v1_events ,name='api_events'),
    url(r'^api/v1/my_coupons/$', views.api_v1_my_coupons ,name='api_my_coupons'),
    url(r'^api/v1/coupons/$', views.api_v1_coupons ,name='api_coupons'),
    url(r'^api/v1/leaderboard/$', views.api_v1_leaderboard ,name='api_leaderboard'),
    url(r'^api/v1/history_events/$', views.api_v1_history_events ,name='api_history_events'),
    url(r'^api/v1/history_coupons/$', views.api_v1_history_coupons ,name='api_history_coupons'),

    url(r'^api/v2/login/$', views.api_v2_login ,name='api_login'),
    url(r'^api/v2/add_event/$', views.api_v2_add_event ,name='api_add_event'),
    url(r'^api/v2/add_coupon/$', views.api_v2_add_coupon ,name='api_add_coupon'),
    url(r'^api/v2/home/$', views.api_v2_home ,name='api_home'),
    url(r'^api/v2/logout/$', views.api_v2_logout ,name='api_logout'),
    url(r'^api/v2/my_events/$', views.api_v2_my_events ,name='api_my_events'),
    url(r'^api/v2/events/$', views.api_v2_events ,name='api_events'),
    url(r'^api/v2/my_coupons/$', views.api_v2_my_coupons ,name='api_my_coupons'),
    url(r'^api/v2/coupons/$', views.api_v2_coupons ,name='api_coupons'),
    url(r'^api/v2/leaderboard/$', views.api_v2_leaderboard ,name='api_leaderboard'),
    url(r'^api/v2/history_events/$', views.api_v2_history_events ,name='api_history_events'),
    url(r'^api/v2/history_coupons/$', views.api_v2_history_coupons ,name='api_history_coupons'),
)


