import framework

import re
import sys

from webob import Request
from webob import exc

class Router(framework.Base):
	'''
	Router takes (route, controller) pairs and simply executes controller when
	it's called as a function.
	'''

	def __init__(self):
		self.routes = []

	def add_route(self, route, controller):
		'''
		Adds the (route, controller) pair to an internal route list.

		Arguments:
		string route -- A regular expression to match the request path
		var controller -- May be a string in the format of "module:Controller" to load,
		or a controller directly.
		'''

		# If controller is a string, load that controller
		if isinstance(controller, basestring):
			controller = self.load(controller)

		self.routes.append((re.compile(route), controller))

	def load(self, controller):
		'''
		Takes a string in the format of "module:Controller" and imports it.

		Returns:
		Controller controller -- The imported controller.
		'''

		module, controller = controller.split(':', 1)

		__import__(module)
		mod = sys.modules[module]
		
		return getattr(module, controller)

	def __call__(self, environ, start_response):
		'''
		Searches through available routes to see if any of them match the current
		request, if so, passes the request off to the controller.

		Returns:
		framework.Response response -- The response from the controller
		'''
		
		self.debug('\nNew Request ----------')
		request = Request(environ)

		self.debug('Remote addr: %s' % request.remote_addr)

		# Try to find /some/ sort of request path
		if (request.path_info == ""):
			request.path_info = request.environ['REQUEST_URI']

		for route, controller in self.routes:
			match = route.match(request.path_info)

			if (match):
				self.debug('Route matched to %s' % request.path_info)
				if (type(controller) == type):
					self.debug('Controller was an Application.')
					# Test to see if it's an Application (has a handle method)
					controller = controller(environ, start_response)
					return controller.handle(match.groupdict())
				else:
					self.debug('Controller was a function.')
					# Alternatively, fall back on the assumption that this is a function
					return controller(environ, start_response, **match.groupdict())
			else:
				self.debug('No route matched to %s' % request.path_info)
		
		# If there is no route, 404
		return exc.HTTPNotFound()(environ, start_response)
