from flask import Flask, redirect, url_for

from .config import ProdConfig, DevConfig
from .extensions import (
                            bcrypt,
                            rest_api,
                            cors
                        )

from .models import db
from .controllers.rest.auth import AuthApi
from .controllers.rest.user import UserApi
from .controllers.rest.profile import ProfileApi
from .controllers.rest.post import PostApi
from .controllers.rest.asset import AssetApi
from .controllers.rest.image import ImageApi
from .controllers.rest.test import TestApi
from .controllers.react import react_blueprint
from .controllers.api import api_blueprint

#-----------------------------------

def create_app(object_name):
    app = Flask(__name__)
    app.config.from_object(object_name)

    db.init_app(app)
    bcrypt.init_app(app)
    cors.init_app(app)   # FIXME: change to only enable in development mode

    rest_api.add_resource(
        AuthApi,
        '/api/auth'
    )
    rest_api.add_resource(
        UserApi,
        '/api/user',
        '/api/user/<string:user_id>'
    )
    rest_api.add_resource(
        ProfileApi,
        '/api/profile',
        '/api/profile/<string:username>'
    )
    rest_api.add_resource(
        PostApi,
        '/api/posts',
        '/api/posts/<int:post_id>'
    )

    rest_api.add_resource(
        AssetApi,
        '/api/asset',
        '/api/asset/<int:asset_id>'
    )

    rest_api.add_resource(
        ImageApi,
        '/api/image',
        '/api/image/<int:image_id>',
        '/api/image/<int:image_id>/<string:image_query>'
    )

    rest_api.add_resource(
        TestApi,
        '/api/test',
        '/api/test/<int:test_id>',
        endpoint='api'
    )
    rest_api.init_app(app)

    #-------------------------------

    #@app.route('/')
    #def index():
    #    return redirect(url_for('react.home'))

    #-------------------------------

    app.register_blueprint(react_blueprint)
    app.register_blueprint(api_blueprint)

    #-------------------------------

    return app

if __name__ == '__main__':
    app.run()
