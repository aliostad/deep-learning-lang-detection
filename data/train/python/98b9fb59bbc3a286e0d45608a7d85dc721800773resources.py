from pyramid.security import Allow
from pyramid.security import Authenticated
#from pyramid.security import Everyone

from . import config


class Root(object):

    __acl__ = [
       (Allow, Authenticated, config.PERMS[0]),  # dashboard
       (Allow, Authenticated, config.PERMS[1]),  # package
       (Allow, 'aclark4life', config.PERMS[2]),  # site

#       (Allow, Everyone, 'manage_dashboard'),
#       (Allow, Everyone, 'manage_package'),
#       (Allow, Everyone, 'manage_site'),

    ]

    def __init__(self, request):
        self.request = request
