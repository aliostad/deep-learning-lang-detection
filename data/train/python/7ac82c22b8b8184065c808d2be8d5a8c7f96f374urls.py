from django.conf.urls import patterns, url
from foradmin.views import PurchaseUpdateView, PaymentUpdateView

urlpatterns = patterns('',

                       url(r'^manage/shipping/$', 'foradmin.views.manage_shipping_view', name='manage_shipping'),
                       # url(r'^manage/purchase/update/(?P<pk>\d+)/$', 'foradmin.views.purchase_update', name='purchase_update'),
                       url(r'^manage/payment/update/$', 'foradmin.views.payment_update', name='payment_update'),
                       url(r'^manage/payment/update/(?P<pk>\d+)/$', 'foradmin.views.payment_update',
                           name='payment_update'),

                       url(
                           regex=r'^function/purchase/update/(?P<pk>\d+)/$',
                           view=PurchaseUpdateView.as_view(),
                           name='function_purchase_update'
                       ),
                       url(
                           regex=r'^function/payment/update/(?P<pk>\d+)/$',
                           view=PaymentUpdateView.as_view(),
                           name='function_payment_update'
                       ),
                       )