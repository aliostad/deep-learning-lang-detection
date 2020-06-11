# -*- coding: utf-8 -*-

from tg import session
from tg.controllers import redirect
from tg.decorators import expose, validate
from brie.config import ldap_config, plugins_config
from brie.lib.ldap_helper import *
from brie.lib.aurore_helper import *
from brie.lib.plugins import *
from brie.model.ldap import *

from brie.controllers import auth
from brie.controllers.auth import AuthenticatedBaseController, AuthenticatedRestController


class PluginsController(AuthenticatedBaseController):
    
    def __init__(self):
        for name, controller_module in plugins_config.plugins.__dict__.iteritems():
            direct_controller_name = "DirectController"

            if direct_controller_name in controller_module.__dict__:
                self.__dict__[name] = controller_module.__dict__[direct_controller_name]()
        #end for
    #end def
#end class
