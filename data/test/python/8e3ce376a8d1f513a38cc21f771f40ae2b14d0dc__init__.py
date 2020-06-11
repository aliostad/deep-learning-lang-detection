# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')
from flask import Flask, render_template, session, redirect, url_for, flash
from flask_mail import Mail

from config import config
from flask_sqlalchemy import SQLAlchemy

from flask_login import LoginManager


db = SQLAlchemy()
login_manager = LoginManager()
login_manager.session_protection = 'strong'
login_manager.login_view = 'user_manage.login'
mail = Mail()

def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    config[config_name].init_app(app)

    login_manager.init_app(app)
    db.init_app(app)
    mail.init_app(app)    

    from server.user_manage import user_manage as server_user_manage_blueprint
    app.register_blueprint(server_user_manage_blueprint,url_prefix='/server/user_manage')

    from server.main import main as server_main_blueprint
    app.register_blueprint(server_main_blueprint)
    
    from server.team_manage import team_manage as server_team_manage_blueprint
    app.register_blueprint(server_team_manage_blueprint,url_prefix='/server/team_manage')

    from server.diary_manage import diary_manage as server_diary_manage_blueprint
    app.register_blueprint(server_diary_manage_blueprint,url_prefix='/server/diary_manage')
    
    from api_1_0.user import user as user_blueprint
    app.register_blueprint(user_blueprint, url_prefix='/api/v1.0/User')


    return app
