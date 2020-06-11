'''
See http://flask.pocoo.org/docs/blueprints/
'''

from code.views.api.api_data import ApiData
from code.views.api.api_meta import ApiMeta
from code.views.api.api_user import ApiUser
from flask import Blueprint
from flask.ext import restful
from shared.config import Config

blueprint_api = Blueprint('api', __name__)

'''
The API
'''

api = restful.Api(blueprint_api)
api.add_resource(ApiMeta, Config.API_BASE + '/meta/<action>')
api.add_resource(ApiUser, Config.API_BASE + '/user/<action>')
api.add_resource(ApiData, Config.API_BASE + '/data/<action>')
