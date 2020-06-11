# -*- coding: utf-8 -*-
"""Main Controller"""
# from routes import Mapper
# from routes import Mapper

from tg import expose, tmpl_context

from trine.controllers.Api.ApiController import ApiController
from trine.controllers.AppController import AppController
from trine.controllers.TGRootController import TGRootController
from trine.lib.base import BaseController
from trine.controllers.error import ErrorController
from trine.controllers.TransactionController import TransactionController
from trine.model import DBSession


__all__ = ['RootController']


# noinspection PyCallingNonCallable
class RootController(BaseController):
    """
    The root controller for the trine application.

    All the other controllers and WSGI applications should be mounted on this
    controller. For example::

        panel = ControlPanelController()
        another_app = AnotherWSGIApplication()

    Keep in mind that WSGI applications shouldn't be mounted directly: They
    must be wrapped around with :class:`TGroot.controllers.WSGIAppController`.

    """

    error = ErrorController()
    api = ApiController()
    app = AppController()
    transaction = TransactionController()

    def __init__(self):
        self._root = TGRootController()

    @expose()
    def _lookup(self, *args):
        # path = request.environ['PATH_INFO']
        # flash(_(r'%s - %s') % (args, path))
        return self._root, args

    def _before(self, *args, **kw):
        tmpl_context.project_name = "Trine"
