import urllib
from google.appengine.ext import webapp, ndb
from . import Manage_BaseHandler
from scripts.database_models.gel_group import GelGroup, GelGroup_Form


class Manage_GelGroups_BaseHandler(Manage_BaseHandler):
    pass


class Manage_GelGroups_Handler(Manage_GelGroups_BaseHandler):
    def get(self):
        self.generate_manage_bar()
        self.template_vars['existingGelGroups'] = GelGroup.gql("ORDER BY DayAndTime ASC").fetch(50)
        self.template_vars['form'] = self.generate_form(GelGroup_Form)

        self.render_template("manage/gel_groups/gel_groups.html")


    def post(self):
        filled_gel_group = self.process_form(GelGroup_Form, GelGroup)
        if filled_gel_group:
            self.redirect(self.request.path)
        else:
            self.redirect(self.request.path + '?edit=%s&retry=1' % self.request.get("edit"))


class Manage_GelGroups_DeleteHandler(Manage_GelGroups_BaseHandler):
    def get(self, urlsafe_key):
        urlsafe_key = str(urllib.unquote(urlsafe_key))
        key = ndb.Key(urlsafe=urlsafe_key)
        if key.kind() == "GelGroup":
            key.delete()
        else:
            self.abort(400, "Can only delete kind 'GelGroup'")
        self.redirect('/manage/gel_groups')


application = webapp.WSGIApplication([
    ('/manage/gel_groups/delete/([^/]+)', Manage_GelGroups_DeleteHandler),
    ('/manage/gel_groups.*', Manage_GelGroups_Handler),
    ], debug=Manage_BaseHandler.debug)
