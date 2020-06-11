# coding: utf-8

import os,logging
from flask import send_from_directory, current_app, request,redirect,url_for,abort,flash
from flask_menu.classy import register_flaskview
from flask_menu import MenuEntryMixin,current_menu
from flask_classful import FlaskView,route
from flask_security import roles_accepted,current_user,login_required


from unifispot.core.views import (
    UserAPI,AdminAPI,ClientAPI,AdminManage,
    ClientManage,AdminDashboard,WifisiteAPI,
    WifisiteManage,SiteDashboard,LandingpageAPI,
    LandingpageManage,FileAPI,LandingpagePreview,
    GuestViewAPI,GuestDataManage,
    AccountAPI,AccountManage,NotificationAPI,
    MailOptionsAPI,MailOptionsManage,TestEmail

)
from unifispot.core.forms import UserForm,get_wifisite_form




def media(filename):
    return send_from_directory(current_app.config.get('MEDIA_ROOT'), filename)


def static_from_root():
    return send_from_directory(current_app.static_folder, request.path[1:])

class IndexView(FlaskView):
    decorators = [login_required]

    def index(self):
        if current_user.type =='admin':
            return redirect(url_for('AdminDashboard:index'))
        elif current_user.type =='client':
            return redirect(url_for('AdminDashboard:index'))     
        else:
            current_app.logger.error("Unknown User Type!! for ID:%s"%current_user.id)
            abort(400)

def configure(app):
    #index view, redirect to corresponding dashboard
    IndexView.register(app, route_base='/')

    AdminDashboard.register(app, route_base='/a/dashboard')
    register_flaskview(app, AdminDashboard)

    #common user api for changing profile details
    UserAPI.register(app, route_base='/user')

    @app.context_processor
    def inject_userform():
        if current_user and current_user.is_authenticated:
            userform = UserForm()
            userform.populate()            
            return dict(userform=userform)
        else:
             return {}            

    @app.context_processor
    def inject_newsiteform():
        if current_user and current_user.is_authenticated:
            newsiteform = get_wifisite_form(baseform=True)
            newsiteform.populate()            
            return dict(newsiteform=newsiteform)
        else:
             return {}

    #adminAPI
    AdminAPI.register(app, route_base='/admin/')
    #client API
    ClientAPI.register(app, route_base='/client/')
    #admin manage view
    AdminManage.register(app, route_base='/a/manage/admin/')
    register_flaskview(app, AdminManage)

    #client manage view
    ClientManage.register(app, route_base='/a/manage/client/')
    register_flaskview(app, ClientManage)
    #account settings API
    AccountAPI.register(app, route_base='/settings/')
    #account manage view
    AccountManage.register(app, route_base='/a/manage/settings/')
    register_flaskview(app, AccountManage)

    #optionsAPI
    MailOptionsAPI.register(app, route_base='/mailoptions/api')
    MailOptionsManage.register(app, route_base='/a/manage/mailoptions/')
    register_flaskview(app, MailOptionsManage)

    #testemail API
    TestEmail.register(app, route_base='/testemail/api')

    #notifications API
    NotificationAPI.register(app, route_base='/notifications/')

    #wifisite API  
    WifisiteAPI.register(app, route_base='/site/')

    WifisiteManage.register(app, route_base='/s/manage/site/<siteid>')
    register_flaskview(app, WifisiteManage)


    SiteDashboard.register(app, route_base='/s/dashboard/<siteid>')
    register_flaskview(app, SiteDashboard)
    #-------------------Landing page --------------------------------

    LandingpageAPI.register(app, route_base='/s/manage/landingpage/<siteid>')

    FileAPI.register(app, route_base='/s/upload/file/<siteid>')

    LandingpageManage.register(app, route_base='/s/landing/<siteid>')
    register_flaskview(app, LandingpageManage)
    
    LandingpagePreview.register(app, route_base='/s/preview/<siteid>')

    #-------------------Guest Data --------------------------------

    GuestViewAPI.register(app, route_base='/s/api/guest/<siteid>')
    
    GuestDataManage.register(app, route_base='/s/data/guest/<siteid>')
    register_flaskview(app, GuestDataManage)   
