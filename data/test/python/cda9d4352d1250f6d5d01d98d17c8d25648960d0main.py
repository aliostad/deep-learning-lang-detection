# -*- coding: utf-8 -*-
import webapp2


from handlers.Misc import *
from handlers.Signup import Signup
from handlers.Backend import *
from handlers.Manage import Manage
from misc.Initialization import *


###self-defined classes
Initialization()
MANAGE_PAGE_RE=r'/([a-zA-Z0-9_-]{1,53})/?$'




'''-----------------------------end of handlers--------------------------------------'''


app = webapp2.WSGIApplication([('/', Front),
                               ('/signup/?$',Signup),
                               ('/login/?$',Login),
                               ('/logoff/?$',Logoff),
                               ('/test/?$',Test),

                               #static pages
                               ('/about/?$', About),
                               ('/nerf/?$',Nerf),

                               #backend channel
                               ('/_admin/backend/?$',Backend),
                               ('/_admin/suspend/?$',Suspend),
                               ('/_admin/resume/?$',Resume),


                               #management pages
                               (MANAGE_PAGE_RE,Manage),
                               ],
                              debug=True)
