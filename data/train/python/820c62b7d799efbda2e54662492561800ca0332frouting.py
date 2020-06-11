from webob.dec import wsgify
import webob
import routes.middleware
from fo.controller import FollowController

def fo_mappers(mapper):
    mapper.connect('/fo/{user_id}',
                    controller=FollowController(),
                    action='fo',
                    conditions={'method': ['GET']})
    mapper.connect('/unfo/{user_id}',
                    controller=FollowController(),
                    action='unfo',
                    conditions={'method': ['GET']})
    mapper.connect('/following/{id}',
                    controller=FollowController(),
                    action='list_following',
                    conditions={'method': ['GET']})
    mapper.connect('/follower/{id}',
                    controller=FollowController(),
                    action='list_follower',
                    conditions={'method': ['GET']})
