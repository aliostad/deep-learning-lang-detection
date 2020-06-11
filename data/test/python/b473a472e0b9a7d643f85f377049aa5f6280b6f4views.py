#!/usr/bin/env python
#-*- coding: utf-8 -*-

__author__ = 'cybersg'

from flask import render_template
from flask_restful import Api
#from flask_login import LoginManager

from cybersg.sgflask import user_api
from scrumteam import app
from scrumteam.rest.generate_history import GenerateHistoryApi
from scrumteam.rest.estimates import EstimatesApi, HistoryApi, SearchTasksApi


@app.route('/')
def index():
    return render_template('index.html')

app.register_blueprint(user_api.user_api)
api = Api(app)
api.add_resource(user_api.UserApi, '/users', endpoint='users')
api.add_resource(user_api.UserApi, '/users/<login>', endpoint='user')

#login_manager = LoginManager(app)

#def load_user(login):
#    pass

api.add_resource(GenerateHistoryApi, '/generate_history', endpoint="generate_history_init")
api.add_resource(GenerateHistoryApi, '/generate_history/<task_id>', endpoint="generate_history_progress")

api.add_resource(EstimatesApi, '/estimates')
api.add_resource(HistoryApi, '/history/<start_sprint>')
api.add_resource(SearchTasksApi, '/search/<phrase>')