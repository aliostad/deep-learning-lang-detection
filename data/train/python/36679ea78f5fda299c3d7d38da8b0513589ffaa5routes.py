#!/usr/bin/env python

from scrobbee.controllers.boxee import BoxeeController
from scrobbee.controllers.index import IndexController
from scrobbee.controllers.settings import SettingsController
from scrobbee.controllers.log import LogController
import cherrypy

def setup():
    mapper = cherrypy.dispatch.RoutesDispatcher()
    
    mapper.connect('main', '/', controller = IndexController(), action = 'index')
    mapper.connect('boxee', '/boxee/add', controller = BoxeeController(), action = 'add')
    mapper.connect('boxee', '/boxee/add/challenge', controller = BoxeeController(), action = 'add_challenge')
    mapper.connect('boxee', '/boxee/add/finish', controller = BoxeeController(), action = 'add_finish')
    mapper.connect('settings', '/settings', controller = SettingsController(), action = 'index')
    mapper.connect('log', '/log', controller = LogController(), action = 'index')

    return mapper