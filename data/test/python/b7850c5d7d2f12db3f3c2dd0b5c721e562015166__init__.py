from flask import Blueprint, render_template
from flask_restplus import Api
from flask_jwt import JWTError


class ErrorFriendlyApi(Api):
    def error_router(self, original_handler, e):
        if type(e) is JWTError:
            return original_handler(e)
        else:
            return super(
                ErrorFriendlyApi,
                self
            ).error_router(
                original_handler,
                e
            )


api_v0 = Blueprint('api', __name__, url_prefix='/api/v0')


api = ErrorFriendlyApi(
    api_v0,
    version='0',
    title='Flarior API',
    description='API for Flarior project.',
    doc='/doc/',
    catch_all_404s=True,
)

from . import auth
