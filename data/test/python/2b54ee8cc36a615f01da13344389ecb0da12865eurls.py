from django.conf.urls import *
from omero_bookings import views

urlpatterns = patterns('django.views.generic.simple',

    url(r'^requests', views.all_requests, name='bookings_requests'),
    url(r'^newaccount/(?P<action>[a-z]+)/$', views.create_account_request, name='bookings_create_account_request'), 
    url(r'^newtraining/(?P<action>[a-z]+)/$', views.create_training_request, name='bookings_create_training_request'), 
    url(r'^accounts/(?P<action>[a-z]+)/(?:(?P<account_id>[0-9]+)/)$', views.manage_account_requests, name='bookings_manage_account_requests'),
    url(r'^trainings/(?P<action>[a-z]+)/(?:(?P<account_id>[0-9]+)/)$', views.manage_training_requests, name='bookings_manage_training_requests'),
    url(r'^instruments/$', views.all_instruments, name='bookings_instruments'),
    url(r'^instruments/(?P<action>[a-z]+)/$', views.manage_instruments, name='bookings_manage_instruments'),
    url(r'^instruments/(?P<action>[a-z]+)/(?:(?P<instrument_id>[0-9]+)/)$', views.manage_instruments, name='bookings_manage_instruments'),
    url(r'^change_password/(?P<account_id>[0-9]+)/$', views.manage_password,
        name='bookings_changepassword'),  
    url(r'^(?P<account_id>[0-9]+)/delete/(?P<action>[a-z]+)/$', views.delete_request, name='bookings_delete_request'),
    url(r'^delete/(?:(?P<instrument_id>[0-9]+)/)$', views.delete_instrument, name='bookings_delete_instrument'),  
 )
