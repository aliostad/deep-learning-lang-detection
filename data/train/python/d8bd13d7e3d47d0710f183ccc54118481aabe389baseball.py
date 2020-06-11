import cherrypy
import json

from api.core import API
##from api.configuration import Configuration
##from api.widget import Widget
##from api.feed.twitter import Twitter
##from api.feed.imap import IMAP
##from api.feed.facebook import Facebook
##from api.feed.tumblr import Tumblr
##from api.feed.flickr import Flickr
##from api.feed.verification import Verification

class Root(object):

    @cherrypy.expose
    def index(self):
        return "Placeholder for web team"


root = Root()
root.api = API()
##root.api.configuration = Configuration()
##root.api.configuration.widget = Widget()
##root.api.facebook = Facebook()
##root.api.imap = IMAP()
##root.api.twitter = Twitter()
##root.api.flickr = Flickr()
##root.api.tumblr = Tumblr()
##root.api.verification = Verification()
# root.api.weather = Weather()
# root.api.busSchedule? = BusSchedule()
# ...

cherrypy.config.update({'server.socket_host': '0.0.0.0', 
                         'server.socket_port': 81, 
                        }) 
cherrypy.quickstart(root)
