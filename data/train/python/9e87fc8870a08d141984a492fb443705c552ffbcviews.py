# -*- coding: utf-8 -*-
"""Manage section"""
from flask import (Blueprint, request, render_template, flash, url_for, redirect, after_this_request)
from flask_security import current_user, login_required, roles_accepted
from test_contracts.extensions import db, user_datastore
from test_contracts.models import Contract
from test_contracts.utils import flash_errors


blueprint = Blueprint("manage", __name__, url_prefix='/manage',
                      static_folder="../static")



# TODO: Manage users for staff
@blueprint.route("/users/", methods=["GET"])
@login_required
@roles_accepted('Staff', 'Admin')
def users():
    return render_template("manage/users.html")