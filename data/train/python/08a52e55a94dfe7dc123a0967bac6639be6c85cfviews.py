__author__ = 'hoangnn'
from flask import Blueprint, redirect, render_template, request
from flask.ext.login import current_user, login_required
from forms import ProfileForm

manage = Blueprint('manage', __name__, url_prefix='/manage')


@manage.route('/', methods=['GET', 'POST'])
@login_required
def index():
    user = current_user
    form = ProfileForm(
        email=current_user.email,
        role_code=current_user.role_code,
        next=request.args.get('next'))
    return render_template('manage/index.html', form=form)
