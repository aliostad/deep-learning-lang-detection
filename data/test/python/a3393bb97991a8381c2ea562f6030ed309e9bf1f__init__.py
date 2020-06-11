# blueberry - Yet another Python web framework.
#
#       http://code.google.com/p/blueberrypy
#
# Copyright 2009 David Reynolds
#
# Use and distribution licensed under the BSD license. See
# the LICENSE file for full text.

import sys

from webob.exc import HTTPNotFound

import blueberry
from blueberry import config
from blueberry.controllers.util import Request, Response

class WSGIApplication(object):

    def __init__(self, debug=False):
        self.debug = debug
        self.controller_classes = {}
        self.app_globals = config.get('blueberry.app_globals')

    def resolve(self, environ, start_response):
        match = environ['wsgiorg.routing_args'][1]
        if not match:
            return

        environ['blueberry.routes_dict'] = match

        controller = match.get('controller')
        if not controller:
            return

        return self.find_controller(controller)

    def find_controller(self, controller):
        if self.controller_classes.has_key(controller):
            return self.controller_classes[controller]

        classname = controller.split('/')[-1].capitalize() + 'Controller'
        dir = config['routes.map'].directory
        # controller.replace in case the controller is nested in multiple directories
        full_mod_name = dir.replace('/', '.') + '.' + controller.replace('/', '.')
        __import__(full_mod_name)

        mycontroller = getattr(sys.modules[full_mod_name], classname)
        self.controller_classes[controller] = mycontroller
        return mycontroller

    def __call__(self, environ, start_response):
        request = Request(environ)
        response = Response()

        # set the thread-local request/response objects
        blueberry.request.set(request)
        blueberry.response.set(response)
        blueberry.app_globals.set(self.app_globals)

        controller = self.resolve(environ, start_response)
        if not controller:
            return HTTPNotFound()(environ, start_response)

        # instantiate if class
        if hasattr(controller, '__bases__'):
            controller = controller()

        return controller(environ, start_response)
