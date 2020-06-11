# -*- coding: utf-8 -*-
"""Main Controller"""

from tg import expose, url, request, redirect

from eventstreamexamples.lib.base import BaseController

from eventstreamexamples.controllers.error import ErrorController

from eventstream import EventstreamController
from geventeventstream import GeventEventstreamController


__all__ = ['RootController']

class RootController(BaseController):
    """
    The root controller for the eventstreamexamples application.

    All the other controllers and WSGI applications should be mounted on this
    controller. For example::

        panel = ControlPanelController()
        another_app = AnotherWSGIApplication()

    Keep in mind that WSGI applications shouldn't be mounted directly: They
    must be wrapped around with :class:`tg.controllers.WSGIAppController`.

    """
    error = ErrorController()

    eventstream = EventstreamController()
    geventeventstream = GeventEventstreamController()

    @expose()
    def index(self):
        return """
<h1><a href="/eventstream">EventStream example</a></h1>
<p>For this, the web app can be run with <b>paster serve --reload development.ini</b>.</p>

<h1><a href="/geventeventstream">EventStream example with gevent</a></h1>
<p>For this, the web app must be run with <b>paster serve development-gunicorn.ini</b>. <strike>reload</strike> gives errors.</p>
"""
