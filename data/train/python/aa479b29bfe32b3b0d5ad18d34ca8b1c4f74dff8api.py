from tastypie.api import Api
from encuestas.api.user import UserResource
from encuestas.api.encuesta import EncuestaResource
from encuestas.api.grupo import GrupoResource
from encuestas.api.pregunta import PreguntaResource
from encuestas.api.opcion import OpcionResource
from encuestas.api.link import LinkResource
from encuestas.api.respuesta import RespuestaResource


v1_api = Api(api_name='v1')
v1_api.register(UserResource())
v1_api.register(EncuestaResource())
v1_api.register(GrupoResource())
v1_api.register(PreguntaResource())
v1_api.register(OpcionResource())
v1_api.register(LinkResource())
v1_api.register(RespuestaResource())
