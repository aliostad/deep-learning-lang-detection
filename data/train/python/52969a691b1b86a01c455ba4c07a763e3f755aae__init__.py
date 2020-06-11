# -*- coding: utf-8 -*-

from flask import Blueprint, jsonify, url_for

#from nbs.api.user import UserApi
from nbs.api.supplier import SupplierApi
from nbs.api.hr import EmployeeApi
from nbs.api.bank_account import BankApi
from nbs.api.purchase_order import PurchaseOrderApi
from nbs.api.product import ProductApi

api = Blueprint('api', __name__, url_prefix='/api')

@api.route('')
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

def configure_api(app):
    app.register_blueprint(api)
    #UserApi.register(app)
    SupplierApi.register(app)
    EmployeeApi.register(app)
    BankApi.register(app)
    PurchaseOrderApi.register(app)
    ProductApi.register(app)
