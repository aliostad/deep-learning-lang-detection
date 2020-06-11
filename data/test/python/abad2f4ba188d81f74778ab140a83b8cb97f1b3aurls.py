from django.conf.urls import patterns, include, url
from monitor import views as statsViews

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'rapidstor.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    # url(r'^monitor/', include('monitor.urls')),
    # url(r'^admin/', include(admin.site.urls)),
    # url(r'^manage/', include('manageCaches.urls'))

    url(r'^rapidstor/stats/', include('monitor.urls')),
    url(r'^rapidstor/manage/', include('manageCaches.urls')),
    url(r'^rapidstor/$', statsViews.home)
)
