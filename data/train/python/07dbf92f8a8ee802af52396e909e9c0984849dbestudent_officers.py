import urllib
from google.appengine.api import images
from google.appengine.ext import webapp, ndb
from . import Manage_BaseHandler
from scripts.database_models.student_officer import StudentOfficer, StudentOfficer_Form


class Manage_StudentOfficers_BaseHandler(Manage_BaseHandler):
    pass


class Manage_StudentOfficers_Handler(Manage_StudentOfficers_BaseHandler):
    def get(self):
        self.generate_manage_bar()
        self.template_vars['existingStudentOfficers'] = StudentOfficer.gql("ORDER BY DisplayOrder ASC").fetch(50)
        self.template_vars['form'] = self.generate_form(StudentOfficer_Form)

        self.render_template("manage/student_officers/student_officers.html")


    def post(self):
        def post_process_model(filled_student_officer):
            filled_student_officer.Image = images.resize(filled_student_officer.Image, 100, 196)

            if not filled_student_officer.DisplayOrder:
                # TODO: only get DisplayOrder
                # displayOrderObject = GqlQuery("SELECT DisplayOrder FROM StudentOfficer ORDER BY DisplayOrder DESC").get()
                displayOrderObject = StudentOfficer.gql("ORDER BY DisplayOrder DESC").get()
                if displayOrderObject and displayOrderObject.DisplayOrder:
                    filled_student_officer.DisplayOrder = displayOrderObject.DisplayOrder + 1
                else:
                    filled_student_officer.DisplayOrder = 1

        filled_student_officer = self.process_form(StudentOfficer_Form, StudentOfficer,
                                                   PostProcessing=post_process_model)
        if filled_student_officer:
            self.redirect(self.request.path)
        else:
            self.redirect(self.request.path + '?edit=%s&retry=1' % self.request.get("edit"))


class Manage_StudentOfficers_OrderHandler(Manage_StudentOfficers_BaseHandler):
    def get(self, direction, displayOrderToMove):
        displayOrderToMove = int(displayOrderToMove)
        # I am assuming displayOrder has no duplicates
        FirstObject = StudentOfficer.gql("WHERE DisplayOrder = :1", displayOrderToMove).get()
        if direction == 'u':
            SecondObject = StudentOfficer.gql("WHERE DisplayOrder < :1 ORDER BY DisplayOrder DESC",
                                              displayOrderToMove).get()
        else:
            SecondObject = StudentOfficer.gql("WHERE DisplayOrder > :1 ORDER BY DisplayOrder ASC",
                                              displayOrderToMove).get()
        FirstObject.DisplayOrder, SecondObject.DisplayOrder = SecondObject.DisplayOrder, FirstObject.DisplayOrder
        FirstObject.put()
        SecondObject.put()
        self.redirect('/manage/student_officers')


class Manage_StudentOfficers_DeleteHandler(Manage_StudentOfficers_BaseHandler):
    def get(self, urlsafe_key):
        urlsafe_key = str(urllib.unquote(urlsafe_key))
        key = ndb.Key(urlsafe=urlsafe_key)
        if key.kind() == "StudentOfficer":
            key.delete()
        else:
            self.abort(400, "Can only delete kind 'StudentOfficer'")
        self.redirect('/manage/student_officers')


application = webapp.WSGIApplication([
    ('/manage/student_officers/order/([ud])/(\d+)', Manage_StudentOfficers_OrderHandler),
    ('/manage/student_officers/delete/([^/]+)', Manage_StudentOfficers_DeleteHandler),
    ('/manage/student_officers.*', Manage_StudentOfficers_Handler),
    ], debug=Manage_BaseHandler.debug)
