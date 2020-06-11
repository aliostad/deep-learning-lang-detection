# -*- coding:utf-8 -*-
import datetime
from flask import Blueprint, redirect, url_for, jsonify, request, make_response
from utils import cn_time_now
from .. import db, app
from .. helpers import user, cache
from . import is_login, render, render_json, render_success

bp = Blueprint('manage', __name__)

@bp.route('/manage/users')
@user.require_admin()
def users():
    pass

@bp.route('/manage/invitation')
@user.require_admin()
def invitation():
    models = db.Invitation.find()
    return render('manage/invitation.html', models=models)

@bp.route('/manage/invitation/generate', methods=['POST'])
@user.require_admin()
def invitation_generate():
    model = db.Invitation()
    model.generate()
    model.save()
    cache.clear_invitation()
    return render_success(model['code'])

