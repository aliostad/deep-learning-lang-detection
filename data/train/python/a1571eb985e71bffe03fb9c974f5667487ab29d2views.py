from django.http import HttpResponse
from django.shortcuts import render_to_response
from meaninglesscodename.core.models import *
from django.contrib.auth.decorators import login_required

import time

def index(request):
    from meaninglesscodename.web.controllers.IndexController import IndexController
    ic = IndexController(request)
    return ic.render_index()
    
def listing(request):
    from meaninglesscodename.web.controllers.IndexController import IndexController
    ic = IndexController(request)
    return ic.render_listing()

def login(request):
    from meaninglesscodename.web.controllers.AuthController import AuthController
    ac = AuthController(request)
    return ac.render_login()

def logout(request):
    from meaninglesscodename.web.controllers.AuthController import AuthController
    ac = AuthController(request)
    return ac.render_logout()

def skeleton(request):
    from meaninglesscodename.web.controllers.IndexController import IndexController
    ic = IndexController(request)
    return ic.render_skeleton()

def base(request):
    from meaninglesscodename.web.controllers.IndexController import IndexController
    ic = IndexController(request)
    return ic.render_base()


# Static Pages (please put at the bottom of this controller)
def about(request):
    from meaninglesscodename.web.controllers.IndexController import IndexController
    ic = IndexController(request)
    return ic.render_about()

def howitworks(request):
    from meaninglesscodename.web.controllers.IndexController import IndexController
    ic = IndexController(request)
    return ic.render_howitworks()

def faq(request):
    from meaninglesscodename.web.controllers.IndexController import IndexController
    ic = IndexController(request)
    return ic.render_faq()

def terms(request):
    from meaninglesscodename.web.controllers.IndexController import IndexController
    ic = IndexController(request)
    return ic.render_terms()

def contact(request):
    from meaninglesscodename.web.controllers.IndexController import IndexController
    ic = IndexController(request)
    return ic.render_contact()
