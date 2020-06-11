"""Scripts bind API resources with the url to the API instance."""
import os
import sys
import inspect
from flask import jsonify, request, abort, make_response, url_for
from flask_httpauth import HTTPBasicAuth
from bucketlist_api import create_app, api
from bucketlist_api.config import DevConfig
from bucketlist_api.resources.bucketlistapi import BucketListAPI
from bucketlist_api.resources.itemlistapi import ItemListAPI
from bucketlist_api.resources.createuserapi import CreateUserAPI
from bucketlist_api.resources.loginuserapi import LoginUserAPI
from bucketlist_api.resources.helpapi import HelpAPI

# initialization
app = create_app(DevConfig)

api.add_resource(HelpAPI, '/help', endpoint='help')
api.add_resource(CreateUserAPI, '/auth/register', endpoint='register')
api.add_resource(LoginUserAPI, '/auth/login', endpoint='login')
api.add_resource(BucketListAPI, '/bucketlists', '/bucketlists/<int:id>',
                 endpoint='bucketlists')
api.add_resource(ItemListAPI, '/bucketlists/<int:bucketlist_id>/items',
                 '/bucketlists/<int:bucketlist_id>/items/<int:item_id>',
                 endpoint='items')
