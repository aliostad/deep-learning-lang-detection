# -*- coding: utf-8 -*-
"""Main Controller"""

from tg import expose, flash, require, url, request, redirect
from pylons.i18n import ugettext as _, lazy_ugettext as l_

from hubreporter.lib.base import BaseController
from hubreporter.model import DBSession, metadata
from hubreporter.controllers.error import ErrorController
from hubreporter.controllers.crc import TicketController, MHPSTicketController

__all__ = ['RootController']


class RootController(BaseController):
    """
    The root controller for the Hub-Reporter application.
    
    All the other controllers and WSGI applications should be mounted on this
    controller. For example::
    
        panel = ControlPanelController()
        another_app = AnotherWSGIApplication()
    
    Keep in mind that WSGI applications shouldn't be mounted directly: They
    must be wrapped around with :class:`tg.controllers.WSGIAppController`.
    
    """
    
    error = ErrorController()

    tickets = TicketController()
    mhps = MHPSTicketController()
    @expose('hubreporter.templates.index')
    def index(self):
        """Handle the front-page."""
        return dict(page='index')

    @expose('hubreporter.templates.about')
    def about(self):
        """Handle the 'about' page."""
        return dict(page='about')


