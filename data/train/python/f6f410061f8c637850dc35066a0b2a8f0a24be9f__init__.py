from flask import Flask
from flask_sqlalchemy import SQLAlchemy

from flask_restful import Api
from app.config import app_config

app = Flask(__name__)
app.config.from_object(app_config['development'])
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)


from app.api import LoginAPI,RegisterAPI,BucketlistsAPI,\
    BucketlistAPI,BucketlistItemsAPI,BucketlistItemAPI

api = Api(app=app, prefix='/api/v1')

api.add_resource(RegisterAPI, '/auth/register', endpoint='register')
api.add_resource(LoginAPI, '/auth/login', endpoint='login')
api.add_resource(BucketlistAPI, '/bucketlists/<int:bucketlist_id>', endpoint='bucketlist')
api.add_resource(BucketlistsAPI, '/bucketlists', endpoint='bucketlists')
api.add_resource(BucketlistItemsAPI, '/bucketlists/<int:bucketlist_id>/items', endpoint='bucketlist_items')
api.add_resource(BucketlistItemAPI, '/bucketlists/<int:bucketlist_id>/items/<int:item_id>', endpoint='bucketlist_item')

