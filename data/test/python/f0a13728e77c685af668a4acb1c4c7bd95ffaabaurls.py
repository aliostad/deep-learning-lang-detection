from django.conf.urls import patterns, include, url
from django.conf import settings

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),

    #API
    url(r'^api/me', 'api.views.me'),
    url(r'^api/login', 'api.views.do_login'),
    url(r'^api/logout', 'api.views.do_logout'),
    url(r'^api/projetos', 'api.views.projetos'),
    url(r'^api/registros', 'api.views.registros'),
    url(r'^api/projeto/(?P<projeto_id>\d+)/checkin', 'api.views.checkin'),
    url(r'^api/projeto/(?P<projeto_id>\d+)/checkout', 'api.views.checkout'),
    url(r'^(?P<path>.*)$', 'django.views.static.serve',
        {'document_root': settings.STATIC_DOC_ROOT, 'show_indexes': True}),

)
