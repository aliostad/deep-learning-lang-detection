from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.IndexView.as_view(), name='index'),
    url(r'^(?P<CustID>[0-9]+)/$', views.detail, name='detail'),
    url(r'^newBill/$', views.newBill, name='newBill'),
    url(r'^save_bill/$', views.save_bill, name='save_bill'),
    url(r'^newPayment/$', views.newPayment, name='newPayment'),
    url(r'^save_payment/$', views.save_payment, name='save_payment'),
    url(r'^(?P<CustID>[0-9]+)/paymentPage/$', views.paymentPage, name='paymentPage')
]
