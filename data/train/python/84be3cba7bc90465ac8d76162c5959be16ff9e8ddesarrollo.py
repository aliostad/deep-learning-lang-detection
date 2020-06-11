"""Desarrollo Controller Info"""
import pylons
from datetime import datetime
from tg.controllers import RestController, redirect
from sgs.lib.base import BaseController
from pylons import request
from tg.decorators import expose, validate, with_trailing_slash
from sgs.model import DBSession
from sgs.model.model import *
from formencode.validators import DateConverter, Int, NotEmpty
from sprox.tablebase import TableBase

from sgs.controllers.administracion.proyecto import ProyectoRestController
from sgs.controllers.desarrollo.fase import FaseRestController
from sgs.controllers.desarrollo.tipo_item import TipoItemRestController
from sgs.controllers.desarrollo.item import ItemRestController
from sgs.controllers.desarrollo.relacion import RelacionRestController

#__all__ = ['DesarrolloController']

class DesarrolloController(BaseController):

    
    proyecto = ProyectoRestController()

    fase = FaseRestController()

    tipo_item = TipoItemRestController()

    item = ItemRestController()

    relacion = RelacionRestController()


    @expose('sgs.templates.desarrollo.desarrollo')
    def index(self):
        """Handle the front-page."""
        return dict(page='index')

   
