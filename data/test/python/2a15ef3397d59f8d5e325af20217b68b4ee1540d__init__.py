"""Main File."""
from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy

# APP SETUP
app = Flask(__name__)
app.config.from_object('config')

# DATABASE SETUP
db = SQLAlchemy(app)

# API SETUP
api = Api(app)

import pokemonAPI.models
import pokemonAPI.resources

db.create_all()
db.session.commit()

api.add_resource(resources.Pokemon, '/api/pokemon/<int:id>')
api.add_resource(resources.PokemonList, '/api/pokemon')
api.add_resource(resources.Trainers, '/api/trainer/<string:name>')
