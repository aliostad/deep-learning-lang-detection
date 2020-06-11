from django.conf.urls import patterns, include, url
from django.contrib import admin
from tastypie.api import Api

from main.api import RequestResource
from main import views

admin.autodiscover()

# Enable v1 API
v1_api = Api(api_name='v1')
v1_api.register(RequestResource())

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'typeme.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^$',  'main.views.index', name='index'),

    url(r'^main/', include('main.urls')),

    # API
    url(r'^api/', include(v1_api.urls)),
)
