import os, sys
from routes.middleware import RoutesMiddleware
from webob import exc, Request, Response

sys.path.append(os.path.dirname(__file__))

from config.urls import urls
import controllers

class Application(object):
    def __call__(self, environ, start_response):
        controller = self.load_controller(environ)
        response = self.dispatch(controller, environ, start_response)
        if not response:
            return exc.HTTPNotFound()(environ, start_response)
        return response

    def load_controller(self, environ):
        """Return controller instance from controller module."""
        url, match = environ['wsgiorg.routing_args']
        if not match:
            return None
        controller = match.get('controller')
        return self.find_controller(controller)

    def find_controller(self, controller):
        """Import controller module."""
        module = 'controllers.' + controller
        __import__(module)
        class_name = controller.title() + 'Controller'
        if hasattr(sys.modules[module], class_name):
            return getattr(sys.modules[module], class_name)

    def dispatch(self, controller, environ, start_response):
        """Dispatch specified controller."""
        if not controller:
            return None
        controller = controller()
        url, match = environ['wsgiorg.routing_args']
        if not match:
            return None
        action = match.get('action')
        return controller(action, environ, start_response)

application = Application()
application = RoutesMiddleware(application, urls)
