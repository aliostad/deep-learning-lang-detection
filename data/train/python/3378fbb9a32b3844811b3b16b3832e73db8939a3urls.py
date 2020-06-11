from django.conf.urls import patterns
from .views import facturas_View, plantilla_poliza_manageView, plantilla_poliza_manageView, plantilla_poliza_delete, preferenciasEmpresa_View

urlpatterns = patterns('',
	(r'^PreferenciasEmpresa/$', preferenciasEmpresa_View),
	(r'^generar_polizas/$', facturas_View),
	#Plantilla Poliza
	(r'^plantilla_poliza/$', plantilla_poliza_manageView),
    (r'^plantilla_poliza/(?P<id>\d+)/', plantilla_poliza_manageView),
    (r'^plantilla_poliza/eliminar/(?P<id>\d+)/', plantilla_poliza_delete),
)