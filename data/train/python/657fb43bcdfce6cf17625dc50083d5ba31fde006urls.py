from django.conf.urls import patterns, url

urlpatterns = patterns('hours.views',
                       url(r'^$', 'my_account', name='index'),
                       url(r'^stuff$', 'stuff', name='stuff'),
                       url(r'^item/(\d*)$', 'item', name='item'),
                       url(r'^hours', 'stuff', name='hours'),
                       url(r'^manage_reservation/(\d*)$', 'manage_reservation', name='manage_reservation'),
                       url(r'^return_form/(\d*)$', 'return_form', name='return_form'),
)
