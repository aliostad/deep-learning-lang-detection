# -*- coding: utf-8 -*-

from flask import render_template, redirect, request, url_for,current_app
from ...models import db,Permission

from . import team_manage
from flask_login import login_user,logout_user,login_required,current_user
from flask.helpers import flash
from ...common_method import commonMethod
import datetime
from ...decorators import server_admin_required,server_permission_required




@team_manage.route('/teammanage', methods=['GET', 'POST'])
@login_required
@server_admin_required
def teamManage():
    if request.method == 'POST':
        print(11)
        

    return render_template('index.html')
@team_manage.route('/membermanage', methods=['GET', 'POST'])
@login_required
@server_permission_required(Permission.COMMENT)
def memberManage():
    if request.method == 'POST':
        print(11)

    return render_template('index.html')