from django.conf.urls.defaults import patterns, url, include
from pycash.controllers import TaxController as controller

urlpatterns = patterns('',
    (r'^upcomingList$', controller.upcomingList),
    (r'^upcoming$', controller.upcoming),
    url(r'^pay$', controller.pay, name="tax_pay"),
    (r'^list$', controller.list),
    url(r'^save$', controller.save_or_update, name="tax_save"),
    (r'^update$', controller.save_or_update),
    url(r'^delete$', controller.delete, name="tax_delete"),
    (r'^$', controller.index)
)
