import urllib
from google.appengine.ext import webapp, blobstore, ndb
from google.appengine.ext.webapp import blobstore_handlers
from . import Manage_BaseHandler
from scripts.database_models.newsletter import Newsletter


class Manage_NewsletterArchive_BaseHandler(Manage_BaseHandler):
    pass


class Manage_NewsletterArchive_Handler(Manage_NewsletterArchive_BaseHandler):
    def get(self):
        self.generate_manage_bar()
        self.template_vars['uploadURL'] = blobstore.create_upload_url('/manage/newsletter_archive/upload')
        self.template_vars['Newsletters'] = Newsletter.gql("ORDER BY DisplayOrder DESC").fetch(50)

        self.render_template("manage/newsletter_archive/newsletter_archive.html")


class Manage_NewsletterArchive_UploadHandler(blobstore_handlers.BlobstoreUploadHandler, Manage_NewsletterArchive_BaseHandler):
    def post(self):
        newNewsletter = Newsletter(
            Title=self.request.get("title"),
            NewsletterBlob=self.get_uploads('file')[0]._BlobInfo__key,
        )
        displayOrderObject = Newsletter.gql("ORDER BY DisplayOrder DESC").get()
        newNewsletter.DisplayOrder = displayOrderObject.DisplayOrder + 1 if displayOrderObject else 1
        newNewsletter.put()
        self.redirect('/manage/newsletter_archive')


class Manage_NewsletterArchive_ServeHandler(blobstore_handlers.BlobstoreDownloadHandler, Manage_NewsletterArchive_BaseHandler):
    def get(self, resource):
        resource = str(urllib.unquote(resource))
        blob_info = blobstore.BlobInfo.get(resource)
        self.send_blob(blob_info)


class Manage_NewsletterArchive_DeleteHandler(Manage_NewsletterArchive_BaseHandler):
    def get(self, urlsafe_key):
        urlsafe_key = str(urllib.unquote(urlsafe_key))
        key = ndb.Key(urlsafe=urlsafe_key)
        if key.kind() == "Newsletter":
            newsletter = key.get()
            blobstore.BlobInfo(newsletter.NewsletterBlob).delete()
            key.delete()
        else:
            self.abort(400, "Can only delete kind 'Newsletter'")
        self.redirect('/manage/newsletter_archive')


class Manage_NewsletterArchive_OrderHandler(Manage_NewsletterArchive_BaseHandler):
    def get(self, direction, displayOrderToMove):
        displayOrderToMove = int(displayOrderToMove)
        # I am assuming displayOrder has no duplicates
        FirstObject = Newsletter.gql("WHERE DisplayOrder = :1", displayOrderToMove).get()
        if direction == 'u':
            SecondObject = Newsletter.gql("WHERE DisplayOrder > :1 ORDER BY DisplayOrder ASC", displayOrderToMove).get()
        else:
            SecondObject = Newsletter.gql("WHERE DisplayOrder < :1 ORDER BY DisplayOrder DESC",
                                          displayOrderToMove).get()
        FirstObject.DisplayOrder, SecondObject.DisplayOrder = SecondObject.DisplayOrder, FirstObject.DisplayOrder
        FirstObject.put()
        SecondObject.put()
        self.redirect('/manage/newsletter_archive')


application = webapp.WSGIApplication([
    ('/manage/newsletter_archive/order/([ud])/(\d+)', Manage_NewsletterArchive_OrderHandler),
    ('/manage/newsletter_archive/delete/([^/]+)', Manage_NewsletterArchive_DeleteHandler),
    ('/manage/newsletter_archive/serve/([^/]+)', Manage_NewsletterArchive_ServeHandler),
    ('/manage/newsletter_archive/upload.*', Manage_NewsletterArchive_UploadHandler),
    ('/manage/newsletter_archive.*', Manage_NewsletterArchive_Handler),
    ], debug=Manage_BaseHandler.debug)
