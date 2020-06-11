'''
Source code for http://www.elfische.ru website.
Released under the MIT license (http://opensource.org/licenses/MIT).
'''
import webapp2
import os
import sys

from controller import (
    PagesController,
    ApiController,
    ChatController,
    CronController,
)


DEBUG = 'Development' in os.environ['SERVER_SOFTWARE']


app = webapp2.WSGIApplication([
    webapp2.Route(r'/<lang:(ru|de)?><:/?>', PagesController, 'home'),
    webapp2.Route(r'/<lang:ru|de>/<page><:/?>', PagesController, 'page'),
    ('/api/(.*)', ApiController),
    ('/_ah/channel/(disconnected|connected)/', ChatController),
    ('/cron/check_users', CronController),
], debug=DEBUG)
