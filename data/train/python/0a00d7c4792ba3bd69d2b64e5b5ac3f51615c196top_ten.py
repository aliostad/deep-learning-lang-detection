import urllib
from google.appengine.ext import webapp, ndb
from . import Manage_BaseHandler
from scripts.database_models.top_ten import TopTen, TopTen_Form


class Manage_TopTen_BaseHandler(Manage_BaseHandler):
    pass


class Manage_TopTen_Handler(Manage_TopTen_BaseHandler):
    def get(self):
        self.generate_manage_bar()
        query = TopTen.query().order(-TopTen.QuestionDate)
        self.template_vars['TopTens'] = query

        self.render_template("manage/top_ten/top_ten.html")


class Manage_TopTenCreate_Handler(Manage_TopTen_BaseHandler):
    def get(self):
        self.generate_manage_bar()
        form = self.generate_form(TopTen_Form)
        if len(form.Answers) == 0:
            for i in xrange(10):
                form.Answers.append_entry()
        self.template_vars['form'] = form

        self.render_template("manage/top_ten/top_ten_create.html")

    def post(self):
        filled_top_ten = self.process_form(TopTen_Form, TopTen)
        if filled_top_ten:
            self.redirect("/manage/top_ten")
        else:
            self.redirect(self.request.path + '?edit=%s&retry=1' % self.request.get("edit"))


class Manage_TopTenDelete_Handler(Manage_TopTen_BaseHandler):
    def get(self, urlsafe_key):
        urlsafe_key = str(urllib.unquote(urlsafe_key))
        key = ndb.Key(urlsafe=urlsafe_key)
        if key.kind() == "TopTen":
            key.delete()
        else:
            self.abort(400, "Can only delete kind 'TopTen'")
        self.redirect("/manage/top_ten")


application = webapp.WSGIApplication([
    ('/manage/top_ten/delete/([^/]+)', Manage_TopTenDelete_Handler),
    ('/manage/top_ten/create', Manage_TopTenCreate_Handler),
    ('/manage/top_ten.*', Manage_TopTen_Handler),
    ], debug=Manage_BaseHandler.debug)
