from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
import logging

from gt.controllers.maps_controller import MapsController
from gt.controllers.messages_controller import MessagesController
from gt.controllers.users_controller import UsersController
from gt.controllers.tweets_controller import TweetsController
from gt.controllers.geocast_controller import GEOCastController

webapp.template.register_template_library('gt.filters')
application = webapp.WSGIApplication([('/', MapsController),
                                      ('/(\d+)', MapsController),
                                      ('/messages', MessagesController),
                                      ('/messages\.json', MessagesController),
                                      ('/messages/(\d+|new)', MessagesController),
                                      ('/messages/(\d+)/(edit|delete)', MessagesController),
                                      ('/users', UsersController),
                                      ('/users/(\d+|new)', UsersController),
                                      ('/users/(\d+)/(edit|delete)', UsersController),
                                      ('/geocast', GEOCastController),
                                      ('/tweets', TweetsController)],
                                     debug=True)

def main():
    run_wsgi_app(application)

if __name__ == "__main__":
    main()
