import os
import cherrypy

from controllers.app import AppController
from controllers.rooms import RoomsController
from controllers.ajax import AJAXController

import config

# Routes

dispatch = cherrypy.dispatch.RoutesDispatcher()

dispatch.connect('register', 'register', controller=AJAXController(), action='register')

dispatch.connect('update', ':name_encoded/update', controller=AJAXController(), action='update')
dispatch.connect('new_message', ':name_encoded/message', controller=AJAXController(), action='new_message')
dispatch.connect('set_topic', ':name_encoded/topic', controller=AJAXController(), action='set_topic')

dispatch.connect('room_new', 'new', controller=RoomsController(), action='new')
dispatch.connect('room_leave', ':name_encoded/leave', controller=RoomsController(), action='leave')
dispatch.connect('room_delete', ':name_encoded/delete', controller=RoomsController(), action='delete')
dispatch.connect('room', ':name_encoded', controller=RoomsController(), action='chat')

dispatch.connect('index', '', controller=RoomsController(), action='index')

# Start server

cherrypy.config.update(config.cherrypy)
cherrypy.quickstart(AppController(), '/', {
  '/': {
    'tools.staticdir.root': os.path.dirname(os.path.abspath(__file__)),
    'request.dispatch': dispatch,
  },
  '/static': {
    'tools.staticdir.on': True,
    'tools.staticdir.dir': 'static'
  }
})