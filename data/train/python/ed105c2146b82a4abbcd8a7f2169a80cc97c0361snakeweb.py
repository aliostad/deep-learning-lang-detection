#!/usr/bin/env python

import inspect
from webob import Request, Response
from webob.exc import HTTPNotFound
import routes

from snakeguice.modules import Module


def is_unbound_method(func):
    return inspect.ismethod(func) and func.im_self is None


class RoutesBinder(object):

    def __init__(self, mapper, annotation):
        self.mapper = mapper
        self._annotation = annotation
        self.controller_map = {}

    def connect(self, *args, **kwargs):
        controller = kwargs.get('controller')

        if controller is None:
            raise TypeError('no controller specified')

        key = unicode((id(controller), repr(controller)))
        self.controller_map[key] = controller
        kwargs['controller'] = key
        self.mapper.connect(*args, **kwargs)

    def match(self, url, environ):
        # TODO: i have a patch that makes this suck less - i need to submit it
        old_environ, self.mapper.environ = self.mapper.environ, environ
        try:
            return self.mapper.match(url)
        finally:
            self.mapper.environ = old_environ


class RoutesModule(Module):

    annotation = None

    def run_configure(self, binder):
        self._mapper = routes.Mapper()
        self.routes_binder = RoutesBinder(self._mapper, self.annotation)
        binder.bind(RoutesBinder,
                to_instance=self.routes_binder,
                annotated_with=self.annotation)

        self.configure(self.routes_binder)
        self._mapper.create_regs([])

    def configure(self, routes_binder):
        raise NotImplementedError


class AutoRoutesModule(RoutesModule):

    def configure(self, routes_binder):
        for route, controller in self.configured_routes.items():
            if hasattr(controller, 'im_class'):
                routes_binder.connect(route,
                        controller=controller.im_class,
                        action=controller.__name__)
            else:
                routes_binder.connect(route, controller=controller)


class Application(object):

    def __init__(self, injector):
        self._injector = injector

    def __call__(self, environ, start_response):
        request = Request(environ)

        binder = self._injector.get_instance(RoutesBinder)

        route = binder.match(environ['PATH_INFO'], environ)
        if not route:
            return HTTPNotFound('no matching route')(environ, start_response)

        controller = route.pop('controller')
        controller = binder.controller_map.get(controller)

        if inspect.isclass(controller):
            action = route.pop('action', 'index')
            controller = self.controller_from_class(controller, action)

        elif is_unbound_method(controller):
            controller = self.controller_from_method(controller)

        elif not callable(controller):
            return HTTPNotFound()(environ, start_response)

        if not controller:
            return HTTPNotFound()(environ, start_response)

        response = controller(request, **route)
        return response(environ, start_response)

    def controller_from_class(self, controller, action):
        controller = self._injector.get_instance(controller)
        return getattr(controller, action, None)

    def controller_from_method(self, controller):
        return self.controller_from_class(controller.im_class,
                controller.__name__)
