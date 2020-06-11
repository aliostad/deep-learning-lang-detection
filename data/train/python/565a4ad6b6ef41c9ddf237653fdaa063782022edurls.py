from django.conf.urls import patterns, url
from trip import views

urlpatterns = patterns('',
    url(r'^save/$', views.save, name='save'),
    url(r'^profile/(?P<slug>[-\w]+)/$', views.trip_profile, name='profile'),
    url(r'^add_activity/$', views.add_activity, name='add_activity'),
    url(r'^get_activities/$', views.get_activities, name='get_activities'),
    url(r'^get_social_activities/$', views.get_social_activities, name='get_social_activities'),
    url(r'^save_comment/$', views.save_comment, name='save_comment'),
    url(r'^save_review/$', views.save_review, name='save_review'),

)