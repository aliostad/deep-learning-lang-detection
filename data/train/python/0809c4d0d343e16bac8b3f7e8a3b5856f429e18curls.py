from django.conf.urls.defaults import patterns, include, url
from django.contrib import admin
from tastypie.api import Api

from rest.api import *

v1_api = Api(api_name='v1')
v1_api.register(ClienteResource())
v1_api.register(TallerResource())
v1_api.register(CiudadResource())
v1_api.register(ConsumibleResource())
v1_api.register(EvidenciaResource())
v1_api.register(MantenimientoResource())
v1_api.register(ServicioResource())
v1_api.register(VehiculoResource())
v1_api.register(RepuestoResource())
v1_api.register(CitaResource())
v1_api.register(TipoTransporteResource())
v1_api.register(ConcesionarioResource())

admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
     url(r'^$', 'vehialpes.rest.views.main', name='home'),
     (r'^api/v1/picoyplaca/(?P<placa>[A-Za-z]{3}[0-9]{3})/$', 'vehialpes.rest.views.picoyplaca'),
     (r'^api/v1/ingreso_post_venta/$', 'vehialpes.rest.views.ingreso_post_venta'),
     (r'^api/v1/ingreso_venta_vehiculos/$', 'vehialpes.rest.views.ingreso_venta_vehiculos'),
     (r'^api/', include(v1_api.urls)),

     url(r'^admin/', include(admin.site.urls)),
)
