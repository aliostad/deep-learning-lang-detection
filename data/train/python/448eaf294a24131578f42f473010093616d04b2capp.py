#!/usr/bin/env python
# -*- coding: utf-8 -*-

from flask import Flask
from flask.ext import restful
from flask.ext.cors import CORS
from flask.ext.sqlalchemy import SQLAlchemy

__app__ = Flask(__name__)
__app__.config.from_object('configs.DevelopmentConfig')
__db__ = SQLAlchemy(__app__)


def get_db():
    return __db__


def get_app():
    return __app__

__api__ = restful.Api(__app__)
__cors__ = CORS(
    __app__,
    resource={
        r"/api/*": {
            "origins": "*",
            "methods": ["GET", "POST", "PUT"]
        }
    }
)


if __name__ == '__main__':
    from models import db
    db.create_all()

    from api import websites
    __api__.add_resource(websites.WebsiteListApi, '/api/websites')
    __api__.add_resource(websites.WebsiteApi, '/api/websites/<website_id>')
    from api import columns
    __api__.add_resource(
        columns.ColumnListApi, '/api/websites/<website_id>/columns')
    __api__.add_resource(
        columns.ColumnApi, '/api/websites/<website_id>/columns/<column_id>')
    from api import articles
    __api__.add_resource(
        articles.ArticleListApi, '/api/websites/<website_id>/columns/<column_id>/articles')
    from api import users
    __api__.add_resource(users.UserListApi, '/api/users')

    __app__.run()
