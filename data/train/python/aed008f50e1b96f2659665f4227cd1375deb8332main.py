import sys

sys.path.append('./src')

from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from admin import AdminServer
from api import ApiServer

application = webapp.WSGIApplication(
                                     [
                                     ('/admin',  AdminServer),
                                     ('/api/GetLoginInfo',  ApiServer),
                                     ('/api/Go', ApiServer),
                                     ('/api/ChargeEnergy', ApiServer),
                                     ('/api/GetCurrentActiveScene', ApiServer),
                                     ('/api/CheckStats', ApiServer),
                                     ('/api/ClearCache', ApiServer)
                                     ],
                                     debug=True)

def main():
    run_wsgi_app(application)

if __name__ == "__main__":
    main()
