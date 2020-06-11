import urllib
from google.appengine.api import images
from google.appengine.ext import webapp, ndb
from . import Manage_BaseHandler
from scripts.database_models.staff_position import StaffPosition, StaffPosition_Form


class Manage_StaffPositions_BaseHandler(Manage_BaseHandler):
    pass


class Manage_StaffPositions_Handler(Manage_StaffPositions_BaseHandler):
    def get(self):
        self.generate_manage_bar()
        self.template_vars['existingStaffPositions'] = StaffPosition.gql("ORDER BY DisplayOrder ASC").fetch(50)
        self.template_vars['form'] = self.generate_form(StaffPosition_Form)

        self.render_template("manage/staff_positions/staff_positions.html")


    def post(self):
        def post_process_model(filled_staff_position):
            filled_staff_position.Image = images.resize(filled_staff_position.Image, 147, 123)

            if not filled_staff_position.DisplayOrder:
                # TODO: only get DisplayOrder
                # displayOrderObject = GqlQuery("SELECT DisplayOrder FROM StudentOfficer ORDER BY DisplayOrder DESC").get()
                displayOrderObject = StaffPosition.gql("ORDER BY DisplayOrder DESC").get()
                if displayOrderObject and displayOrderObject.DisplayOrder:
                    filled_staff_position.DisplayOrder = displayOrderObject.DisplayOrder + 1
                else:
                    filled_staff_position.DisplayOrder = 1

        filled_staff_position = self.process_form(StaffPosition_Form, StaffPosition, PostProcessing=post_process_model)
        if filled_staff_position:
            self.redirect(self.request.path)
        else:
            self.redirect(self.request.path + '?edit=%s&retry=1' % self.request.get("edit"))


class Manage_StaffPositions_OrderHandler(Manage_StaffPositions_BaseHandler):
    def get(self, direction, displayOrderToMove):
        displayOrderToMove = int(displayOrderToMove)
        # I am assuming displayOrder has no duplicates
        FirstObject = StaffPosition.gql("WHERE DisplayOrder = :1", displayOrderToMove).get()
        if direction == 'u':
            SecondObject = StaffPosition.gql("WHERE DisplayOrder < :1 ORDER BY DisplayOrder DESC",
                                              displayOrderToMove).get()
        else:
            SecondObject = StaffPosition.gql("WHERE DisplayOrder > :1 ORDER BY DisplayOrder ASC",
                                              displayOrderToMove).get()
        FirstObject.DisplayOrder, SecondObject.DisplayOrder = SecondObject.DisplayOrder, FirstObject.DisplayOrder
        FirstObject.put()
        SecondObject.put()
        self.redirect('/manage/staff_positions')


class Manage_StaffPositions_DeleteHandler(Manage_StaffPositions_BaseHandler):
    def get(self, urlsafe_key):
        resource = str(urllib.unquote(urlsafe_key))
        key = ndb.Key(urlsafe=resource)
        if key.kind() == "StaffPosition":
            key.delete()
        else:
            self.abort(400, "Can only delete kind 'StaffPosition'")
        self.redirect('/manage/staff_positions')


application = webapp.WSGIApplication([
    ('/manage/staff_positions/order/([ud])/(\d+)', Manage_StaffPositions_OrderHandler),
    ('/manage/staff_positions/delete/([^/]+)', Manage_StaffPositions_DeleteHandler),
    ('/manage/staff_positions.*', Manage_StaffPositions_Handler),
    ], debug=Manage_BaseHandler.debug)
