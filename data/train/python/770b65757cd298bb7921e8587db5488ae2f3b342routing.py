from webob.dec import wsgify
import webob
import routes.middleware
from users.controller import UserController

def user_mappers(mapper):
    mapper.connect('/user/token',
                   controller=UserController(),
                   action='token',
                   conditions={'method': ['POST']})
    mapper.connect('/user/token/{token}',
                   controller=UserController(),
                   action='get_user_from_token',
                   conditions={'method': ['GET']})
    mapper.connect('/user/list',
                    controller=UserController(),
                    action='list',
                    conditions={'method': ['GET']})
    mapper.connect('/user/create',
                    controller=UserController(),
                    action='create',
                    conditions={'method': ['POST']})
    mapper.connect('/user/{id}/update',
                    controller=UserController(),
                    action='update',
                    conditions={'method': ['PUT']})
    mapper.connect('/user/{id}/profile',
                    controller=UserController(),
                    action='profile',
                    conditions={'method': ['GET']})
    mapper.connect('/user/search/{name}',
                    controller=UserController(),
                    action='search',
                    conditions={'method': ['GET']})
    mapper.connect('/user/{id}/delete',
                    controller=UserController(),
                    action='delete',
                    conditions={'method': ['DELETE']})
    mapper.connect('/user/validate/{validate_code}',
                    controller=UserController(),
                    action='validate_email',
                    conditions={'method': ['GET']})
    mapper.connect('/user/check_email/{email}',
                    controller=UserController(),
                    action='check_email',
                    conditions={'method': ['GET']})
    mapper.connect('/user/check_username/{username}',
                    controller=UserController(),
                    action='check_username',
                    conditions={'method': ['GET']})
    mapper.connect('/user/password',
                    controller=UserController(),
                    action='update_password',
                    conditions={'method': ['POST']})


