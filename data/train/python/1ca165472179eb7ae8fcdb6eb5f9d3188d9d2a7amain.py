#!/usr/bin/env python
import web

import auth
import controller
from notfoundcontroller import NotFoundController
from profilecontroller import ProfileController
from resumecontroller import ResumeController
from listcontroller import ListController


urls = (
    r'/login', 'login',
    r'/logout', 'logout',
    r'/profile', 'ProfileController',
    r'/resume', 'ResumeController',
    r'/resume/create', 'ResumeGenerationController',
    r'/admin', 'ListController',
    r'/admin/(.+)', 'ListController',
    r'/', 'IndexController',
)


class IndexController(controller.Controller):
    pass


class login(object):
    def GET(self):
        return auth.login(web.ctx.env.get('HTTP_REFERER'))


class logout(object):
    def GET(self):
        return auth.logout('/')


application = web.application(urls, globals())
application.notfound = NotFoundController()

app = application.wsgifunc()
