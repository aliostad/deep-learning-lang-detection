from webob.dec import wsgify
import webob
import routes.middleware
from attachments.controller import AttachmentController

def attachment_mappers(mapper):
    mapper.connect('/attachments/thumbnail/{id}',
                   controller=AttachmentController(),
                   action='thumbnail',
                   conditions={'method': ['GET']})
    mapper.connect('/attachments/source/{id}',
                   controller=AttachmentController(),
                   action='source',
                   conditions={'method': ['GET']})
    mapper.connect('/attachments/download/{id}',
                   controller=AttachmentController(),
                   action='download',
                   conditions={'method': ['GET']})
    mapper.connect('/attachments/upload',
                   controller=AttachmentController(),
                   action='upload',
                   conditions={'method': ['POST']})
    mapper.connect('/attachments/middle_size/{id}',
                   controller=AttachmentController(),
                   action='middle_size',
                   conditions={'method': ['GET']})
    mapper.connect('/attachments/upload_avatar/{user_id}',
                    controller=AttachmentController(),
                    action='upload_avatar',
                    conditions={'method': ['POST']})
    mapper.connect('/attachments/upload_avatar_small/{user_id}',
                    controller=AttachmentController(),
                    action='upload_avatar_small',
                    conditions={'method': ['POST']})
    mapper.connect('/attachments/avatar/{id}',
                    controller=AttachmentController(),
                    action='avatar',
                    conditions={'method': ['GET']})
    mapper.connect('/attachments/avatar_small/{id}',
                    controller=AttachmentController(),
                    action='avatar_small',
                    conditions={'method': ['GET']})

