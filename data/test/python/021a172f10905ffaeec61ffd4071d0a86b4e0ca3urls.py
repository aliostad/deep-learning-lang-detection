from django.conf.urls.defaults import *

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

handler404 = 'public_api_site.api.views.default'

urlpatterns = patterns('',
# Documentation says location vs locations - adding until it's figured out
# Judas (ston) 6/29
    (r'^api/location[/]$', 'public_api_site.api.views.locations'),

    (r'^api/speakers[/]$', 'public_api_site.api.views.speakers'),
    (r'^api/talks[/]$', 'public_api_site.api.views.talks'),
    (r'^api/interests[/]$', 'public_api_site.api.views.interests'),
    (r'^api/stats[/]$', 'public_api_site.api.views.stats'),
    (r'^api/users[/]$', 'public_api_site.api.views.users'),

    (r'^$','public_api_site.api.views.default'),
    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # (r'^admin/(.*)', admin.site.root),
)
