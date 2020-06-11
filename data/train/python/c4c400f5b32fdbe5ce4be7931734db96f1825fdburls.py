from django.conf.urls import patterns, include, url
from django.contrib import admin
from tastypie.api import Api

from centros.api import *
from clientes.api import *
from compras.api import *
from contactos.api import *
from cotizaciones.api import *
from equipos.api import *
from familias.api import *
from historiales.api import *
from lugares.api import *
from productos.api import *
from proveedores.api import *
from solicitudes.api import *
from tiposequipos.api import *
from usuarios.api import *
from usuarios.views import *


v1_api = Api(api_name="v1")
v1_api.register(CentroResource())
v1_api.register(ClienteResource())
v1_api.register(CompraResource())
v1_api.register(ContactoResource())
v1_api.register(CotizacionResource())
v1_api.register(EquipoResource())
v1_api.register(FamiliaResource())
v1_api.register(HistorialResource())
v1_api.register(LugarResource())
v1_api.register(ProductoResource())
v1_api.register(NombreProductoResource())
v1_api.register(FotoProductoResource())
v1_api.register(UnidadProductoResource())
v1_api.register(PrecioMesProductoResource())
v1_api.register(ProveedorResource())
v1_api.register(SolicitudResource())
v1_api.register(ProductoSolicitudResource())
v1_api.register(TipoEquipoResource())
v1_api.register(UsuarioResource())
v1_api.register(ConsolidadorSolicitanteResource())
v1_api.register(SolicitanteCodificadorResource())
v1_api.register(AprobadorSolicitudesSolicitanteResource())
v1_api.register(AprobadorSolicitudesCompradorResource())
v1_api.register(CompradorAprobadorComprasResource())
v1_api.register(AprobadorComprasAlmacenistaResource())

urlpatterns = patterns("",
	(r"^api/", include(v1_api.urls)),
	(r"^admin/", include(admin.site.urls))
)