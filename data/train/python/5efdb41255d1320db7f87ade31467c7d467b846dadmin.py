"""Admin controler"""

import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to
from formalchemy.ext.pylons.admin import FormAlchemyAdminController

from archeologicalcollection.lib.base import BaseController, render
from archeologicalcollection.model import meta
from archeologicalcollection import model
from archeologicalcollection import forms


log = logging.getLogger(__name__)

class AdminController(BaseController):
    model = model
    forms = forms

    def Session(self): # Session factory
        return meta.Session

AdminController = FormAlchemyAdminController(AdminController)
