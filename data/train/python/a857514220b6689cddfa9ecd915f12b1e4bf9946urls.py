# Routing logic for API and html
from django.conf.urls import patterns, include, url

urlpatterns = patterns('',
    # Homepage
    url(r'^$', 'globalizr.views.home'),
    url(r'^home/$', 'globalizr.views.home'),
    # About page
    url(r'^about/$', 'globalizr.views.about'),

    # API
    #-- query
    url(r'^api/query/(\w+)/$', 'globalizr.api.views.query'),
    
    #-- interface
    url(r'^api/interface/(\w+)/$', 'globalizr.api.views.interface'),
    url(r'^api/interface/(\w+)/(\w+)/$', 'globalizr.api.views.interface'),

    #-- faulty API calls
    url(r'^api/.*$', 'globalizr.api.views.error'),
 
    #-- catchall, since there's no point in 404-ing
    url(r'^*$/', 'globalizr.views.home')
)
