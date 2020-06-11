from django.conf.urls import url

from . import views

app_name = 'banking_system'
urlpatterns = [
    url(r'^$', views.login, name='login'),
    url(r'^create_user/$', views.create_user, name='create_user'),
    url(r'^create_account/$', views.create_account, name='create_account'),
    url(r'^user_portal/$', views.user_portal, name='user_portal'),
    url(r'^adminPortal/$', views.adminPortal, name='adminPortal'),
    url(r'^adminPortal/manageCustomers/$', views.manageCustomers, name='manageCustomers'),
    url(r'^adminPortal/manageCustomers/editCustomer$', views.editCustomer, name='editCustomer'),
    url(r'^adminPortal/manageCustomers/addCustomer$', views.addCustomer, name='addCustomer'),
    url(r'^adminPortal/manageAccounts/$', views.manageAccounts, name='manageAccounts'),
    url(r'^adminPortal/manageAccounts/addAccount$', views.addAccount, name='addAccount'),
    url(r'^adminPortal/manageAccounts/editAccount$', views.editAccount, name='editAccount'),
    url(r'^adminPortal/manageAccountTypes/$', views.manageAccountTypes, name='manageAccountTypes'),
    url(r'^manageCustomers/$', views.manageCustomers, name='manageCustomers'),
    url(r'^userPortal/summary/$', views.summary, name='summary'),
    url(r'^userPortal/withdraw/$', views.withdraw, name='withdraw'),
    url(r'^userPortal/deposit/$', views.deposit, name='deposit'),
    url(r'^userPortal/transfer$', views.transfer, name='transfer'),
]
