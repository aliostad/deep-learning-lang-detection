from django.conf.urls import patterns, include, url
from django.contrib import admin

urlpatterns = patterns('base.views',
    # Examples:
    # url(r'^$', 'project_name.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    url(r'^home/', 'home', name='home'), # grappelli URLS
)

urlpatterns += patterns('base.api',
    url(r'^api/signin/?$', 'api_signin', name="api_signin" ),
    url(r'^api/signout/?$', 'api_signout', name="api_signin" ),
    url(r'^api/signup/?$', 'api_create_user', name='api_create_user'),
    url(r'^api/save_score/?$', 'api_save_score', name='api_save_score'),
)
