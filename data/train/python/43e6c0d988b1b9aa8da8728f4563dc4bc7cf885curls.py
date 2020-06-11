from django.conf.urls import patterns, url
from django.views import generic
from .views import generar_polizas_View, preferenciasEmpresa_View, plantilla_poliza_manageView

urlpatterns = patterns('',
	(r'^GenerarPolizas/$', generar_polizas_View),
	(r'^PreferenciasEmpresa/$', preferenciasEmpresa_View),
	#Plantilla Poliza
	(r'^plantilla_poliza/$', plantilla_poliza_manageView),
    (r'^plantilla_poliza/(?P<id>\d+)/', plantilla_poliza_manageView),
    #(r'^plantilla_poliza/eliminar/(?P<id>\d+)/', plantilla_poliza_delete),
)