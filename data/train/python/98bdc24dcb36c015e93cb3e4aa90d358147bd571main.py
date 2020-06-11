import sys
import os

import cherrypy

from apps.api.apiPageHandler import Api

__author__ = "Patrick Meyer"

class Root():
	def index(self):
		return "You found the index. There is nothing here. Go, use the API."
		#raise cherrypy.HTTPRedirect("/example/")


if __name__ == '__main__':
	ip = '127.0.0.1'
	port = 8000
#	ip = '81.169.244.213'
#	port = 8080

	cherrypy.config.update({'server.socket_host': ip})
	cherrypy.config.update({'server.socket_port': port})

	index_controller = Root()
	api_controller = Api()

	d = cherrypy.dispatch.RoutesDispatcher()
	d.connect(name='root',		action='index',								controller=index_controller,	route='/')

	d.connect(name='api',		action='register',							controller=api_controller,	route='/api/register')
	d.connect(name='api',		action='login',								controller=api_controller,	route='/api/login')	
	d.connect(name='api',		action='getUsers',							controller=api_controller,	route='/api/getUsers')
	d.connect(name='api',		action='getPositionsMap',					controller=api_controller,	route='/api/getPositionsMap')
	d.connect(name='api',		action='getUserPath',						controller=api_controller,	route='/api/getUserPath')
	d.connect(name='api',		action='getTopTenScoresForAllMinigames',	controller=api_controller,	route='/api/getTopTenScoresForAllMinigames')
	d.connect(name='api',		action='getAllLogbookEntriesByUser',		controller=api_controller,	route='/api/getAllLogbookEntriesByUser')
	d.connect(name='api',		action='secretValidForNextCache',			controller=api_controller,	route='/api/secretValidForNextCache')
	d.connect(name='api',		action='makeGuestbookEntry',				controller=api_controller,	route='/api/makeGuestbookEntry')
	d.connect(name='api',		action='getGuestbookIndex',					controller=api_controller,	route='/api/getGuestbookIndex')
	d.connect(name='api',		action='getGuestbookEntryById',				controller=api_controller,	route='/api/getGuestbookEntryById')

	d.connect(name='api',		action='nop',								controller=api_controller,	route='/api/nop')
	d.connect(name='api',		action='updatePosition',					controller=api_controller,	route='/api/updatePosition')
	d.connect(name='api',		action='makeLogbookEntry',					controller=api_controller,	route='/api/makeLogbookEntry')
	d.connect(name='api',		action='markPuzzleSolved',					controller=api_controller,	route='/api/markPuzzleSolved')
	d.connect(name='api',		action='submitGameScore',					controller=api_controller,	route='/api/submitGameScore')


	config_dict = {
		'/': {
			'request.dispatch': d
		}
	}

	cherrypy.tree.mount(None, config=config_dict)
	cherrypy.engine.start()
	cherrypy.engine.block()
