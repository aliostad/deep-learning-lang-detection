from wsgi_basic.common import wsgi
from wsgi_basic.token import controllers


class Router(wsgi.ComposableRouter):

    def add_routes(self, mapper):
        token_controller = controllers.Auth()
        mapper.connect('/tokens',
                       controller=token_controller,
                       action='authenticate',
                       conditions=dict(method=['POST']))
        mapper.connect('/tokens/{token_id}',
                       controller=token_controller,
                       action='delete_token',
                       conditions=dict(method=['DELETE']))
        mapper.connect('/tokens/{token_id}',
                       controller=token_controller,
                       action='validate_token',
                       conditions=dict(method=['GET']))
