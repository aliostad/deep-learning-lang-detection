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
    url(r'^acidentes_rodovias/$', 'app.controller.index_controller.index'),
    url(r'^acidentes_rodovias/regiao$', 'app.controller.consultabasica_regiao_controller.consulta_por_regiao'),
    url(r'^acidentes_rodovias/periodo$', 'app.controller.consultabasica_periodo_controller.consulta_por_periodo'),
    url(r'^acidentes_rodovias/municipios-regiao$', 'app.controller.consultabasica_regiao_controller.consulta_municipios_na_regiao'),
    url(r'^acidentes_rodovias/consulta/municipio$', 'app.controller.consultabasica_regiao_controller.consulta_ocorrencias_por_municipio'),
    url(r'^acidentes_rodovias/consulta/periodo$', 'app.controller.consultabasica_periodo_controller.consulta_ocorrencias_por_periodo'),

    url(r'^acidentes_rodovias/estatisticas/tipos-acidentes$', 'app.controller.estatisticas_tipos_controller.tipos_acidentes'),
    url(r'^acidentes_rodovias/estatisticas/causas-acidentes$', 'app.controller.estatisticas_causas_controller.causas_acidentes'),
    url(r'^acidentes_rodovias/estatisticas/ocorrencias-envolvidos$', 'app.controller.estatisticas_envolvidos_controller.ocorrencias_e_envolvidos'),
    url(r'^acidentes_rodovias/estatisticas/acidentes-sexo$', 'app.controller.estatisticas_envolvidos_controller.acidentes_sexo'),
    url(r'^acidentes_rodovias/estatisticas/br$', 'app.controller.estatisticas_br_controller.acidentes_br'),
    url(r'^acidentes_rodovias/estatisticas/uf$', 'app.controller.estatisticas_uf_controller.acidentes_uf'),
)
