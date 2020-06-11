import os
from flask import Flask
from flask_restful import Api

from models import db
from v1.ColorLegendAPI import ColorLegendAPI
from v1.MealsAPI import MealsListAPI, MealAPI
from v1.TokenAPI import TokenAPI
from v1.UserAPI import UserAPI
from v1.UserListAPI import UserListAPI
from v1.CategoryListAPI import CategoryListAPI
from v1.CategoryAPI import CategoryAPI
from v1.InvitesAPI import InvitesListAPI, InviteAPI
from v1.GroupAPI import GroupAPI


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.cookchooser'
app.config['SECRET_KEY'] = os.environ.get('COOKCHOOSER_KEY') or 'cookchooser secret key'
app.config['ERROR_404_HELP'] = False

api_path = '/cookchooser/api/v1/'

db.init_app(app)

api = Api(app)

api.add_resource(UserListAPI, api_path + 'users')
api.add_resource(TokenAPI, api_path + 'token')
api.add_resource(MealsListAPI, api_path + 'meals')
api.add_resource(MealAPI, api_path + 'meals/<string:uuid>')
api.add_resource(UserAPI, api_path + 'users/<int:user_id>')
api.add_resource(CategoryListAPI, api_path + 'categories')
api.add_resource(CategoryAPI, api_path + 'categories/<int:cat_id>')
api.add_resource(InvitesListAPI, api_path + 'invites')
api.add_resource(InviteAPI, api_path + 'invites/<int:inv_id>')
api.add_resource(GroupAPI, api_path + 'group')
api.add_resource(ColorLegendAPI, api_path + 'legend')

if __name__ == "__main__":
    app.run(host='0.0.0.0')
