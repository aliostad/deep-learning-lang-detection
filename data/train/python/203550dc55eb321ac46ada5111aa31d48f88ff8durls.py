from django.conf.urls.defaults import *
from django.contrib import admin
admin.autodiscover()
from BuiltyMaker.main.models import *
urlpatterns = patterns('BuiltyMaker.main.views',
	#	(r'^$', 'index'),
        (r'^newconsignment','new_consignment'),
        (r'^addpayment', 'add_payment'),
        (r'^addfreight', 'add_freight'),
        (r'^genbuilty', 'generate_builty'),
        (r'^cons_register', 'consignment_register'),
		(r'^prev_cons', 'prev_cons'),
		(r'^dispatch', 'dispatch'),
		(r'^confirm_dispatch','confirm_dispatch'),
)
