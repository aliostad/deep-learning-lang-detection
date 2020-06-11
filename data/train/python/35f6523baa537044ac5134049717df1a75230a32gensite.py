import logging, webapp2, controller


application = webapp2.WSGIApplication([webapp2.Route('/_site/admin', handler=controller.AdminHandler),
    webapp2.Route('/_site/admin/download_commit', handler=controller.AdminHandler, handler_method='download_commit'),
    webapp2.Route('/_site/admin/download', handler=controller.AdminHandler, handler_method='download'),
    webapp2.Route('/_site/refresh', handler=controller.RefreshHandler),
    webapp2.Route(r'/<path:.*>', handler=controller.AssetHandler)], debug=True)

