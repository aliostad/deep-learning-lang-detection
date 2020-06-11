from web.core import request
import djrq.middleware
import web
from web.auth import authorize
from web.core.templating import render
from datetime import datetime
from djrq.model import *
from sqlalchemy.sql import func, or_
from time import time
from ..basecontroller import BaseController
from suggestionscontroller import SuggestionsController
from mistagscontroller import MistagsController
from requestscontroller import RequestsController
from options import OptionsController
from upload import UploadController
from sitenewscontroller import SiteNewsController

from account import AccountMixIn

web.auth.in_group = web.auth.ValueIn.partial('groups')
web.auth.has_permission = web.auth.ValueIn.partial('permissions')

class Admin(BaseController, AccountMixIn):
    #def __init__(self, id):
    #    print "Starting admin"
    #    super(Resource, self).__init__()
    suggestions = SuggestionsController()
    mistags = MistagsController()
    requests = index = RequestsController()
    options = OptionsController()
    upload = UploadController()
    sitenews = SiteNewsController()

