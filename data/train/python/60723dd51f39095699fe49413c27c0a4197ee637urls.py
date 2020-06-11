from django.conf.urls.defaults import *
from django.conf import settings

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Example:
    # (r'^sensorsafe_broker/', include('sensorsafe_broker.foo.urls')),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    (r'^admin/', include(admin.site.urls)),

		(r'^$', 'django.contrib.auth.views.login'),
		(r'^files/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_DOC_ROOT}),
		(r'login/$', 'django.contrib.auth.views.login'),
		(r'login$', 'django.contrib.auth.views.login'),
		(r'register/$', 'broker.views.register'),
		(r'register$', 'broker.views.register'),
		(r'profile/$', 'broker.views.profile'),
		(r'profile$', 'broker.views.profile'),
		(r'logout/$', 'broker.views.logout_view'),
		(r'logout$', 'broker.views.logout_view'),

		(r'register_contributor/$', 'broker.views.register_contributor'),
		(r'register_contributor$', 'broker.views.register_contributor'),
		
		(r'get_consumers/$', 'broker.views.get_consumers'),
		(r'get_consumers$', 'broker.views.get_consumers'),

		(r'display/$', 'broker.views.display'),
		(r'display$', 'broker.views.display'),

		(r'get_username/$', 'broker.views.get_username'),
		(r'get_username$', 'broker.views.get_username'),
		
		(r'search_contributors/$', 'broker.views.search_contributors'),
		(r'search_contributors$', 'broker.views.search_contributors'),
		
		(r'get_contributors/$', 'broker.views.get_contributors'),
		(r'get_contributors$', 'broker.views.get_contributors'),
)
