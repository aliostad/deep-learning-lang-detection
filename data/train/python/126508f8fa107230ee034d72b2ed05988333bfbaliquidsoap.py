from flask import render_template
from flask.ext.login import login_required, current_user

import rfk.liquidsoap
from rfk.site.helper import permission_required

from ..admin import admin


@admin.route('/liquidsoap/manage')
@login_required
@permission_required(permission='manage-liquidsoap')
def liquidsoap_manage():
    return render_template('admin/liquidsoap/management.html')


@admin.route('/liquidsoap/config')
@login_required
@permission_required(permission='manage-liquidsoap')
def liquidsoap_config():
    config = rfk.liquidsoap.gen_script().encode('utf-8')
    return render_template('admin/liquidsoap/config.html', liq_config=config)
