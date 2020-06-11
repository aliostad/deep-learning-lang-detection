"""Main File."""
from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy
from flask_httpauth import HTTPBasicAuth
import os

# APP SETUP
app = Flask(__name__)
app.config.from_object('config')

# SETUP
db = SQLAlchemy(app)
api = Api(app)
auth = HTTPBasicAuth()

import apiStuff.models
import apiStuff.resources

if not os.path.exists('app.db'):
    db.create_all()
    db.session.commit()
    apiStuff.scraping.scrape_all()

api.add_resource(apiStuff.resources.Article, '/api/articles/<int:id>')
api.add_resource(apiStuff.resources.Articles, '/api/articles')
api.add_resource(apiStuff.resources.Event, '/api/event/<int:id>')
api.add_resource(apiStuff.resources.AddUser, '/api/users')
api.add_resource(apiStuff.resources.GetUser, '/api/users/<int:id>')
api.add_resource(apiStuff.resources.Token, '/api/token')
