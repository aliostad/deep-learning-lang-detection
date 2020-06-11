from django.conf.urls import patterns, url
from bob import views

urlpatterns = patterns('',
 #  url(r'^$', views.index, name='index'),
  url(r'customer/(?P<customer_id>\d+)/$', views.customer, name='account'),
#   url(r'^/customer/(?<account_id>\d+/$', views.customer, name='customer'),
  url(r'customer/manage/(?P<customer_id>\d+)/$', views.manageCustomer, name='manageCustomer'),
  url(r'customer/new/(?P<customer_id>\d+)/$', views.newCustomer, name='newCustomer'),
  url(r'customer/delete/(?P<customer_id>\d+)/$', views.deleteCustomer, name='deleteCustomer'),
  url(r'transfer/$', views.transfer, name='transfer'),
  url(r'bank/(?P<bank_id>\d+)/$', views.bank, name='bank'),
  url(r'bank/manage/(?P<customer_id>\d+)/$', views.manageBank, name='manageBank'),
)