from flask_restful import Api

from .app import app
from .resources.session import SessionAPI
from .resources.user import UserListAPI, UserAPI
from .resources.offer import BookOfferAPI, BookOfferListAPI


def register_resources(api):
    api.add_resource(UserListAPI, '/users', endpoint='users')
    api.add_resource(UserAPI, '/users/<int:id>', endpoint='user')
    api.add_resource(SessionAPI, '/users/login', endpoint='login')
    api.add_resource(BookOfferListAPI, '/offers', endpoint='offers')
    api.add_resource(BookOfferAPI, '/offers/<int:id>', endpoint='offer')

api = Api(app)
register_resources(api)
