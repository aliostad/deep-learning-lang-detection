#!/usr/bin/env python

import wsgiref.handlers

from google.appengine.ext import webapp
import sbugs
from post import CreatePost, DisplayPost, EditPost, DeletePost, ManagePages, DisplayNews, EditNews, DeleteNews
from sbuser import SetAlias, Login, Logout, Register, ManageUsers, Confirm
from session import ManageSession, EditSession, DisplaySessions

from photos import ManageGalleries, ViewGallery, ImagesXML, GallerySWF, GetImage, GetThumb, QuickUpload
from files import ManageFiles, GetFile

YAHOO_APPID = '2Jbx0yvV34HWgMKIfe0PQppGYz9LvZj5m2_jBbSJzPddShB5Ue.3hSkNsD75zmmJDA--'

def main():
    application = webapp.WSGIApplication(
      [
        ('/', sbugs.FrontPage),
        
        # display news posts and pages
        ('/news', DisplayNews),
	('/news/edit/(.*)', EditNews),
	('/news/delete/(.*)', DeleteNews),
        ('/(.*).html', DisplayPost),
        
        # post and page management
        ('/post', CreatePost),
        ('/page/manage', ManagePages),
        ('/page/delete/(.*)', DeletePost),
        ('/page/edit/(.*)', EditPost),
        ('/page/(.*)', DisplayPost),
        
        # user management
        ('/user/alias', SetAlias),
        ('/user/login', Login),
        ('/user/logout', Logout),
        ('/user/register', Register),
        ('/user/manage', ManageUsers),
        ('/user/confirm', Confirm),

        # photo gallery management
        ('/gallery', ManageGalleries),
        #('/gallery/(.*)/gallery.swf', GallerySWF),
        ('/gallery/(.*)/(.*)_thumb\.(png|jpg)', GetThumb),
        ('/gallery/(.*)/(.*)\.(png|jpg)', GetImage),
        ('/gallery/(.*)/images.xml', ImagesXML),
        ('/gallery/(.*)/view', ViewGallery),
        ('/gallery/(.*)/upload', QuickUpload),

	# file management
	('/files', ManageFiles),
	('/files/?(.*)/(.*)\.([a-zA-Z]+)', GetFile),

        # play session management
        ('/session', DisplaySessions),
        ('/session/manage', ManageSession),
        ('/session/edit/(.*)', EditSession),
        
        # google login - required to add first user
        ('/login', sbugs.Login),
        
      ],
      debug=False)
    wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
