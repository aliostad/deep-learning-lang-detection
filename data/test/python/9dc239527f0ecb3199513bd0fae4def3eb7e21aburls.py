from django.conf.urls.defaults import *

urlpatterns = patterns('',
  #url(r'^create$', 'api.views.create', name='api_create'),
  url(r'^register$', 'api.views.register', name='api_register'),
  url(r'^register/submit$', 'api.views.register_submit', name='api_register_submit'),
  
  #url(r'^v0.1/course$', 'api.v01_views.course', name='api_course'),
  #url(r'^v0.1/network$', 'api.v01_views.network', name='api_course'),
  #url(r'^v0.1/session$', 'api.v01_views.session', name='api_course'),
  
  #(r'^v0.1/', include('api.v01.urls')),

  url(r'^(?P<session_slug>[-\w]+)/(?P<slugs>.+)', 'networks.views.course', name='course_detail'),
)