from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'acidentes_em_rodovias.controller.home', name='home'),
    # url(r'^acidentes_em_rodovias/', include('acidentes_em_rodovias.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
    url(r'^bar_tender_mixer/$', 'app.controller.bar_controller.index'),
    url(r'^bar_tender_mixer/1$', 'app.controller.bar_controller.opcao1'),
    url(r'^bar_tender_mixer/2$', 'app.controller.bar_controller.opcao2'),
    url(r'^bar_tender_mixer/3$', 'app.controller.bar_controller.opcao3'),
    url(r'^bar_tender_mixer/4$', 'app.controller.bar_controller.opcao4'),
    url(r'^bar_tender_mixer/5$', 'app.controller.bar_controller.opcao5'),
    url(r'^bar_tender_mixer/6$', 'app.controller.bar_controller.opcao6'),
    url(r'^bar_tender_mixer/7$', 'app.controller.bar_controller.opcao7'),
    url(r'^bar_tender_mixer/8$', 'app.controller.bar_controller.opcao8'),	
)
