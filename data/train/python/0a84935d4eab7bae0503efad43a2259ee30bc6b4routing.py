from webob.dec import wsgify
import webob
import routes.middleware
from comments.controller import CommentController

def comment_mappers(mapper):
    mapper.connect('/comment/{pin_id}/create',
                   controller=CommentController(),
                   action='create',
                   conditions={'method': ['POST']})
    mapper.connect('/comment/{pin_id}',
                   controller=CommentController(),
                   action='list',
                   conditions={'method': ['GET']})
    mapper.connect('/comment/{pin_id}/{comment_id}/reply',
                   controller=CommentController(),
                   action='reply',
                   conditions={'method': ['POST']})
    mapper.connect('/comment/{comment_id}/update',
                   controller=CommentController(),
                   action='update',
                   conditions={'method': ['PUT']})
    mapper.connect('/comment/{comment_id}/delete',
                   controller=CommentController(),
                   action='delete',
                   conditions={'method': ['DELETE']})

