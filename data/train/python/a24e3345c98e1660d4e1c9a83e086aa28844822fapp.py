from flask import Flask
from flask.ext.restful import Api
from flask.ext.restful.utils import cors
from flask_mail import Mail
from model import db, redis_store
from api.userAPI import UserAPI, LoginAPI, FBUserAPI, FBLoginAPI, ActivateAPI
from api.profileAPI import ProfileAPI, ProfileIconAPI, SearchProfileAPI
from api.friendsAPI import FriendsListAPI, FriendsRequestAPI
from api.passwordAPI import ChangePasswordAPI, ForgetPasswordAPI
from api.postAPI import PostAPI

# load configuration and bootstrap flask
app = Flask(__name__)
app.config.from_object('config')

db.init_app(app)
redis_store.init_app(app)
mail = Mail(app)

api = Api(app)
api.decorators = [cors.crossdomain(origin='*',
                                   headers='my-header, accept, content-type, token')]

# add endpoints to flask restful api 
api.add_resource(UserAPI, '/create_user')
api.add_resource(LoginAPI, '/login')
api.add_resource(FBUserAPI, '/fb_create_user')
api.add_resource(FBLoginAPI, '/fb_login')
api.add_resource(ActivateAPI, '/activate_account')

api.add_resource(ChangePasswordAPI, '/change_password')
api.add_resource(ForgetPasswordAPI, '/forget_password')

api.add_resource(ProfileAPI, '/profile')
api.add_resource(ProfileIconAPI, '/upload_profile_icon')
api.add_resource(SearchProfileAPI, '/search_profile')

api.add_resource(FriendsListAPI, '/friends_list')
api.add_resource(FriendsRequestAPI, '/friends_request')

api.add_resource(PostAPI, '/post')

if __name__ == '__main__':
    app.run(debug=True)
