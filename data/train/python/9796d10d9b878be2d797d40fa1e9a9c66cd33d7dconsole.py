import webapp2
from . import api


class HomeHandler(webapp2.RequestHandler):
    def get(self, prefix):
        self.redirect(prefix + '/deferredconsole/static/index.html')


application = webapp2.WSGIApplication([
    (r'.+/deferredconsole/api/logs/([\w\d-]+)', api.LogHandler),
    (r'.+/deferredconsole/api/([\w\d-]+)/([\w\d-]+)/rerun', api.ReRunTaskHandler),
    (r'.+/deferredconsole/api/([\w\d-]+)/([\w\d-]+)', api.TaskInfoHandler),
    (r'.+/deferredconsole/api/([\w\d-]+)', api.QueueHandler),
    (r'.+/deferredconsole/api.*', api.QueueListHandler),
    (r'(.+)/deferredconsole.*', HomeHandler),
])
