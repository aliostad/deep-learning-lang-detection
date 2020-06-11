"""
    Searchr Server
    --------------

    Searchr is a simple fulltext search engine with a restful api.

    :copyright: (c) 2013 by Thomas O'Donnell
    :license: BSD, see LICENSE for more details.
    :version: 0.1
"""
#-----------------------------------------------------------------------------#
# Setup
#-----------------------------------------------------------------------------#
from flask import Flask, send_from_directory
from flask.ext.sqlalchemy import SQLAlchemy 
from flask.ext.restful import Api


app = Flask(__name__, )
app.config.from_pyfile('config/main.py')

db = SQLAlchemy(app)
api = Api(app)

#-----------------------------------------------------------------------------#
# Register API Routes
#-----------------------------------------------------------------------------#
from views.api_v1 import DocumentAPI, DocumentListAPI, PingAPI, TagAPI,\
    TagListAPI, DocumentTagAPI, IndexAPI, SearchAPI

api.add_resource(PingAPI, '/api/v1.0/ping', '/api/v1.0/ping/')
api.add_resource(DocumentAPI, '/api/v1.0/document/<int:id>', endpoint='document')
api.add_resource(DocumentListAPI, '/api/v1.0/document', '/api/v1.0/document/')
api.add_resource(TagAPI, '/api/v1.0/tag/<int:id>', endpoint='tag')
api.add_resource(TagListAPI, '/api/v1.0/tag', '/api/v1.0/tag/')
api.add_resource(DocumentTagAPI, '/api/v1.0/document/<int:doc_id>/tag/<int:tag_id>')
api.add_resource(IndexAPI, '/api/v1.0/index')
api.add_resource(SearchAPI, '/api/v1.0/document/search')
