# -*- coding: utf-8 -*-

from flask import Blueprint, jsonify, url_for, request, session, escape
from nbs.api.user import user_api
from nbs.api.supplier import supplier_api
from nbs.api.product import product_api
from nbs.api.document import document_api

api = Blueprint('api', __name__, url_prefix='/api')

def configure_api(app):
    app.register_blueprint(api)
    app.register_blueprint(user_api)
    app.register_blueprint(supplier_api)
    app.register_blueprint(product_api)
    app.register_blueprint(document_api)

@api.route('/')
def index():
    return jsonify({
        'message': "This is api root.",
        'docs': url_for('api.documentation'),
    })

@api.route('/docs')
def documentation():
    return jsonify({
        'message': "Documentation",
    })
