from django.conf.urls.defaults import patterns, url, include
from pycash.controllers import ExpenseController as controller

urlpatterns = patterns('',
    (r'^stats$', controller.stats),
    (r'^calc$', controller.calc),
    (r'^monthCalc$', controller.monthCalc),
    (r'^sixMonthCalc$', controller.sixMonthCalc),
    url(r'^list$', controller.list, name="expenses_list"),
    url(r'^save$', controller.save_or_update, name="expenses_save"),
    url(r'^update$', controller.save_or_update, name="expenses_update"),
    url(r'^delete$', controller.delete, name="expenses_delete"),
    (r'^$', controller.index)
)


