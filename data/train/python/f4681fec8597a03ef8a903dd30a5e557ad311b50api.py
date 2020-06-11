# -*- coding: utf-8 -*-

from flask import Blueprint, abort, g, request

api_blueprint = Blueprint('api_v1', __name__, url_prefix='/api')


@api_blueprint.before_request
def api_blueprint_before_request():
    api_version = request.headers.get('X-ApiVersion', None)
    if api_version not in ('1', '2'):
        abort(400)

    g.api_version = api_version


@api_blueprint.route('/')
def get_api_index():
    result = None
    if g.api_version == 1:
        result = 'Hello, APIv1!'
    else:
        result = 'Hello, APIv2!'

    return result
