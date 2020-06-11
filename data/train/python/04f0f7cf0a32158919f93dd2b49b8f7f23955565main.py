## Mike Creehan ##
## CherryPy2 assignment ##
## March 5 2014 ##

import cherrypy
from mcont import MovieController
from ucont import UserController
from vcont import VoteController
from rcont import ResetController
from racont import RatingController
from fcont import FavoriteController
from _movie_database import _movie_database

class OptionsController:
	def OPTIONS(self, *args, **kwargs):
		return ""

def CORS():
	cherrypy.response.headers["Access-Control-Allow-Origin"] = "*"
	cherrypy.response.headers["Access-Control-Allow-Methods"] = "GET, PUT, POST, DELETE, OPTIONS"
	cherrypy.response.headers["Access-Control-Allow-Credentials"] = "true"

def start_service():
	dispatcher = cherrypy.dispatch.RoutesDispatcher()
	mdb = _movie_database()

	movieController = MovieController(mdb)
	userController = UserController(mdb)
	voteController = VoteController(mdb)
	ratingController = RatingController(mdb)
	resetController = ResetController(mdb)
	favoriteController = FavoriteController(mdb)
	optionsController = OptionsController()

	#MOVIES
	dispatcher.connect('movie_get', '/movies/:movie_id', controller=movieController, action='GET', conditions=dict(method=['GET']))
	dispatcher.connect('movie_put', '/movies/:movie_id', controller=movieController, action='PUT', conditions=dict(method=['PUT']))
	dispatcher.connect('movie_delete', '/movies/:movie_id', controller=movieController, action='DELETE', conditions=dict(method=['DELETE']))

	dispatcher.connect('movie_get_idx', '/movies/', controller=movieController, action='GET_INDEX', conditions=dict(method=['GET']))
	dispatcher.connect('movie_post_idx', '/movies/', controller=movieController, action='POST_INDEX', conditions=dict(method=['POST']))
	dispatcher.connect('movie_delete_idx', '/movies/', controller=movieController, action='DELETE_INDEX', conditions=dict(method=['DELETE']))
	
	#USERS
	dispatcher.connect('user_get', '/users/:user_id', controller=userController, action='GET', conditions=dict(method=['GET']))
	dispatcher.connect('user_put', '/users/:user_id', controller=userController, action='PUT', conditions=dict(method=['PUT']))
	dispatcher.connect('user_delete', '/users/:user_id', controller=userController, action='DELETE', conditions=dict(method=['DELETE']))

	dispatcher.connect('user_get_idx', '/users/', controller=userController, action='GET_INDEX', conditions=dict(method=['GET']))
	dispatcher.connect('user_post_idx', '/users/', controller=userController, action='POST_INDEX', conditions=dict(method=['POST']))
	dispatcher.connect('user_delete_idx', '/users/', controller=userController, action='DELETE_INDEX', conditions=dict(method=['DELETE']))

	#VOTING/RECOMMENDATIONS
	dispatcher.connect('votes_get', '/recommendations/:user_id', controller=voteController, action='GET', conditions=dict(method=['GET']))
	dispatcher.connect('votes_put', '/recommendations/:user_id', controller=voteController, action='PUT', conditions=dict(method=['PUT']))
	dispatcher.connect('votes_delete_idx', '/recommendations/', controller=voteController, action='DELETE_INDEX', conditions=dict(method=['DELETE']))

	#FAVORITES
	dispatcher.connect('favs_get', '/favorites/:user_id', controller=favoriteController, action='GET', conditions=dict(method=['GET']))
	dispatcher.connect('favs_put', '/favorites/:user_id', controller=favoriteController, action='PUT', conditions=dict(method=['PUT']))
	dispatcher.connect('favs_put_idx', '/favorites/', controller=favoriteController, action='GET_INDEX', conditions=dict(method=['GET'])) 
	dispatcher.connect('favs_post_idx', '/favorites/', controller=favoriteController, action='POST_INDEX', conditions=dict(method=['POST']))
	dispatcher.connect('favs_delete', '/favorites/:user_id', controller=favoriteController, action='DELETE', conditions=dict(method=['DELETE']))
	dispatcher.connect('favs_delete_idx', '/favorites/', controller=favoriteController, action='DELETE_INDEX', conditions=dict(method=['DELETE']))

	#RATINGS
	dispatcher.connect('ratings_get', '/ratings/:movie_id', controller=ratingController, action='GET', conditions=dict(method=['GET']))

	#RESET
	dispatcher.connect('reset_all', '/reset/', controller=resetController, action='PUT', conditions=dict(method=['PUT']))

	#OPTIONS
	dispatcher.connect('movie_options', '/movies/:movie_id', controller=optionsController, action='OPTIONS', conditions=dict(method=['OPTIONS']))
	dispatcher.connect('movie_index_options', '/movies/', controller=optionsController, action='OPTIONS', conditions=dict(method=['OPTIONS']))
	dispatcher.connect('user_options', '/users/:user_id', controller=optionsController, action='OPTIONS', conditions=dict(mehtod=['OPTIONS']))
	dispatcher.connect('user_index_options', '/users/', controller=optionsController, action='OPTIONS', conditions=dict(method=['OPTIONS']))
	dispatcher.connect('votes_options', '/recommendations/:user_id', controller=optionsController, action='OPTIONS', conditions=dict(method=['OPTIONS']))
	dispatcher.connect('votes_index_options', '/recommendations/', controller=optionsController, action='OPTIONS', conditions=dict(method=['OPTIONS']))
	dispatcher.connect('ratings_options', '/ratings/:movie_id', controller=optionsController, action='OPTIONS', conditions=dict(method=['OPTIONS']))
	dispatcher.connect('favorites_options', '/favorites/:user_id', controller=optionsController, action='OPTIONS', conditions=dict(method=['OPTIONS']))
	dispatcher.connect('favorites_index_options', '/favorites/', controller=optionsController, action='OPTIONS', conditions=dict(method=['OPTIONS']))


	conf = { 
		'global' : {
		'server.socket_host' : 'student00.cse.nd.edu', 
		'server.socket_port' : 40009,
		},
		'/':{
		'request.dispatch' : dispatcher, 'tools.CORS.on': True,
		} 
	}

	cherrypy.config.update(conf)
	app = cherrypy.tree.mount(None, config=conf)
	cherrypy.quickstart(app)

if __name__ == '__main__':
	cherrypy.tools.CORS = cherrypy.Tool('before_finalize', CORS)
	start_service()
