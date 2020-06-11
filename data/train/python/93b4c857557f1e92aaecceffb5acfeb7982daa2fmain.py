#!/usr/bin/env python

import sys

from app.controller import api_controller
from google.appengine.ext import webapp
from google.appengine.ext.webapp import util

def main():
    application = webapp.WSGIApplication( [
        ( '/', api_controller.PublicController ),
        ( '/api/public', api_controller.PublicController ),
        ( '/api/presenter', api_controller.PresenterController ),
        ( '/api/participant', api_controller.ParticipantController ),
        ( '/presenter/login', api_controller.LoginController ),
        ( '/participant/login', api_controller.LoginController )
    ], debug=True )
    util.run_wsgi_app( application )

if __name__ == '__main__':
    main()
