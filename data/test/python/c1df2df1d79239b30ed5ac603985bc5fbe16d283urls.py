from django.conf.urls import patterns, url

from schedule import views

urlpatterns = patterns('',
    url(r'^$', views.main),
    url(r'^signin$', views.signin),
    url(r'^signup$', views.signup),
    url(r'^select$', views.select),

    url(r'^api/csrftoken$', views.api_csrftoken),

    url(r'^api/signin$', views.api_signin),
    url(r'^api/signout$', views.api_signout),
    url(r'^api/signup$', views.api_signup),

    url(r'^api/schedule$', views.api_schedule),

    url(r'^api/subscribe_event$', views.api_subscribe_event),
    url(r'^api/unsubscribe_event$', views.api_unsubscribe_event),

    url(r'^api/subscribe_channel$', views.api_subscribe_channel),
    url(r'^api/unsubscribe_channel$', views.api_unsubscribe_channel),

    url(r'^api/subscribe_target$', views.api_subscribe_target),
    url(r'^api/unsubscribe_target$', views.api_unsubscribe_target),

    url(r'^api/events$', views.api_events),
    url(r'^api/channels$', views.api_channels),
    url(r'^api/targets$', views.api_targets),
)
