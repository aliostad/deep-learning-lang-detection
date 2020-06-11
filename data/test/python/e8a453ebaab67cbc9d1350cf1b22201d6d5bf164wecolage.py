# wecolage.py - Eric Conlon - Sept 2009

from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

import home_controller
import paste_controller
import user_controller
import friends_controller
		
application = webapp.WSGIApplication(
	[
		('/', 							home_controller.Home), 			  # GET
		('/about/?',					home_controller.About),			  # GET
		('/404/?', 						home_controller.FourOhFour),	  # GET
		('/login/?',					home_controller.Login), 		  # GET
		('/logout/?', 					home_controller.Logout), 		  # GET
		('/paste/new/?', 				paste_controller.Paster), 		  # GET/POST
		('/paste/(.+)/fork/?', 			paste_controller.Forker), 		  # GET
		('/paste/(.+)/download(/.+)?', 	paste_controller.Filer),	 	  # GET
		('/paste/(.+)/?', 				paste_controller.Reader), 		  # GET
		('/profile(/.+)?',				user_controller.Profile), 		  # GET
		('/settings/?', 				user_controller.Settings), 		  # GET/POST
		('/friends/request/(.+)', 		friends_controller.RequestFriend),# POST
		('/friends/remove/(.+)', 		friends_controller.RemoveFriend), # POST
		('/friends/reject/(.+)', 		friends_controller.RejectRequest),# POST
		('/friends/approve/(.+)',		friends_controller.ApproveRequest),# POST
		('/friends(/.+)?', 				friends_controller.ListFriends),  # GET
		('/.*',							home_controller.FourOhFour)
	],
	debug = True
)

def main():
	run_wsgi_app(application)
	