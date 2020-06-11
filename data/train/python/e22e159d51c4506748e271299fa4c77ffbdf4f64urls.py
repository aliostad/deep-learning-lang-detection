from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'CopaBroker.views.home', name='home'),
    # url(r'^CopaBroker/', include('CopaBroker.foo.urls')),
    url(r'^$', 'broker.views.grupos'),
    url(r'^noticias/$', 'broker.views.news'),
    url(r'^grupos/$', 'broker.views.grupos'),
    url(r'^painel/(\w+)/$', 'broker.views.painel'),
    url(r'^minhas_ordens/$', 'broker.views.minhas_ordens'),
    url(r'^minha_carteira/$', 'broker.views.minha_carteira'),
    url(r'^fundamentos/$', 'broker.views.fundamentos'),
    url(r'^tutorial/$', 'broker.views.tutorial'),
    url(r'^cadastro/$', 'broker.views.cadastro'),
    url(r'^book/(\w+)/$', 'broker.views.book'),
    url(r'^login/$', 'broker.views.login_user'),
    url(r'^logout/$', 'broker.views.logout_user')
)
