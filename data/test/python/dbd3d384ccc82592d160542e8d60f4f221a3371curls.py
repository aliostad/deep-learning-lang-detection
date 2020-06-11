from django.conf.urls import patterns, include, url
from django.contrib import admin


from main.api import JobResource, AttenderResource
from tastypie.api import Api
import main.api

api = Api(api_name='v1')
api.register(main.api.JobResource())
api.register(main.api.AttenderResource())


urlpatterns = patterns('',
    # Examples:
    url(r'^$', 'main.views.home', name='home'),
    # url(r'^dashboard/', 'main.views.dashboard', name='dashboard'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^api/', include(api.urls)),
    url(r'^admin/', include(admin.site.urls)),
)
