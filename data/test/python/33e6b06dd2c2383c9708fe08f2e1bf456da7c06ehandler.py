from tori.controller import Controller as BaseController
from tori.controller import RestController as BaseRestController
from tori.socket.rpc import Interface as BaseInterface

class Controller(BaseController):
    @property
    def authenticated(self):
        """:rtype: council.security.document.Credential"""
        return self.session.get('user')

    def render_template(self, template_name, **contexts):
        contexts['core'] = {
            'user': self.authenticated
        }

        return super(Controller, self).render_template(template_name, **contexts)

class RestController(BaseRestController):
    @property
    def authenticated(self):
        return self.session.get('user')

class WSRPCInterface(BaseInterface):
    @property
    def authenticated(self):
        return self.session.get('user')