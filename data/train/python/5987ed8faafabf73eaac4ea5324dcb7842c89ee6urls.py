
try:
	from django.conf.urls import url, patterns
except ImportError:  # remove when django 1.5 fully integrated
	from django.conf.urls.defaults import url, patterns
from MHLogin.MHLSignup.forms import OfficeManagerWizard, OfficeStaffWizard, \
	ProviderWizard, BrokerWizard


# place app url patterns here
urlpatterns = patterns('MHLogin.MHLSignup',
	(r'^$', 'views.register'),
	(r'^Success/$', 'views.success'),
	(r'^provider_success/$', 'views.provider_success'),
	(r'^broker_Success/$', 'views.provider_success'),
	(r'^broker_Success/$', 'views.broker_success'),

	#these urls are hardcoded in views.py due to circular import issues with reverse()
	#make sure you update views.py if they change
	url(r'^Practice/$', OfficeManagerWizard('/signup/Success'), name='practice-signup'),
	url(r'^Staff/$', OfficeStaffWizard('/signup/Success'), name='staff-signup'),
	url(r'^Provider/$', ProviderWizard('/signup/provider_success'), name='provider-signup'),
	url(r'^Staff2/$', OfficeStaffWizard('/signup/Manager_Success'), name='staff-signup2'),
	url(r'^Provider2/$', OfficeStaffWizard('/signup/Manager_Success'), name='provider-signup2'),
	url(r'^Broker/$', BrokerWizard('/signup/broker_Success'), name='broker-signup'),
)
