from flask import Flask, render_template, make_response
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy
from config import Config
from flask_heroku import Heroku

app = Flask(__name__)
app.config.from_object('config.DevelopmentConfig')

# heroku = Heroku(app)

api = Api(app)
db = SQLAlchemy(app)


#import resources
from .resources import Index, UserListAPI, SongsListAPI, ArtistsListAPI, AlbumsListAPI, SongAPI, UserAPI, AlbumAPI, ArtistAPI, SignUp, Home, SignIn

API_VERSION = Config.API_VERSION
#register resources
api.add_resource(Home,
                 '/'.format(version=API_VERSION))
api.add_resource(Index,
                 '/index'.format(version=API_VERSION))
api.add_resource(SignUp,
                 '/signup'.format(version=API_VERSION))
api.add_resource(SignIn,
                 '/signin'.format(version=API_VERSION))
api.add_resource(UserListAPI,
                 '/users'.format(version=API_VERSION),
                 endpoint='users', strict_slashes=False)
api.add_resource(UserAPI,
                 '/users/<int:id>'.format(version=API_VERSION),
                 endpoint='user', strict_slashes=False)
api.add_resource(SongsListAPI,
                 '/songs'.format(version=API_VERSION),
                 endpoint='songs', strict_slashes=False)
api.add_resource(SongAPI,
                 '/songs/<int:id>'.format(version=API_VERSION),
                 endpoint='song', strict_slashes=False)
api.add_resource(ArtistsListAPI,
                 '/artists'.format(version=API_VERSION),
                 endpoint='artists', strict_slashes=False)
api.add_resource(ArtistAPI,
                 '/artists/<int:id>'.format(version=API_VERSION),
                 endpoint='artist', strict_slashes=False)
api.add_resource(AlbumsListAPI,
                 '/albums'.format(version=API_VERSION),
                 endpoint='albums', strict_slashes=False)
api.add_resource(AlbumAPI,
                 '/albums/<int:id>'.format(version=API_VERSION),
                 endpoint='album', strict_slashes=False)

@app.after_request
def add_cors_headers(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Credentials', 'true')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type, Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
    return response



