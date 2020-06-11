# -*- coding: utf-8 -*-
import os
## warningが出るのでコメントアウト
#os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'

from google.appengine.dist import use_library
use_library('django', '1.2')

from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

import logging
import tanarky.controller

application = webapp.WSGIApplication(
  [(r'/', tanarky.controller.PageHome),
   (r'/reject',         tanarky.controller.PageReject),
   (r'/result',         tanarky.controller.PageResult),
   (r'/twitter',        tanarky.controller.PageTwitter),
   (r'/twitter/offer',  tanarky.controller.PageTwitterOffer),
   (r'/receive',        tanarky.controller.PageReceive),
   (r'/facebook',       tanarky.controller.PageFacebook),
   (r'/facebook/offer', tanarky.controller.PageFacebookOffer),
   (r'/result',         tanarky.controller.PageResult),
   (r'/login/twitter',  tanarky.controller.LoginTwitter),
   (r'/login/facebook', tanarky.controller.LoginFacebook),
   (r'/logout',         tanarky.controller.Logout),
   (r'/test',           tanarky.controller.PageTest),
   (r'/.*',             tanarky.controller.Error),
   ],
  debug=True)

def main():
  #logging.getLogger().setLevel(logging.DEBUG)
  #logging.info(__name__)
  run_wsgi_app(application)

if __name__ == "__main__":
  #logging.getLogger().setLevel(logging.DEBUG)
  logging.getLogger().setLevel(logging.INFO)
  main()
