from flask import Blueprint
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
    title='My Flask App API',
    description='API for My Flask App.',
    doc='/doc/',
    catch_all_404s=True,
)

from . import auth
