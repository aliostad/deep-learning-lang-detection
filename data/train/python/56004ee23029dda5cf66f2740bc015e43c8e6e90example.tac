from twisted.application import service, internet

from twistler.controllers import BaseController, AppController, StaticController

from nevow import tags, loaders, appserver

class TestController(BaseController):
    def index(self, ctx, id):
        return loaders.stan(tags.html[tags.body["index id is: %s" % str(id)]]).load(ctx)[0]

    def show(self, ctx, id):
        t = tags.html[tags.body[self.path(controller="user", action="show", id=123)]]
        return loaders.stan(t).load(ctx)[0]
    
AppController.addController(TestController, ['', 'test'])


class CSSController(StaticController):
    PATH = "examples/static"

AppController.addController(CSSController)


application = service.Application('pubsubin')
site = appserver.NevowSite(AppController())
webServer = internet.TCPServer(8080, site)
webServer.setServiceParent(application)

