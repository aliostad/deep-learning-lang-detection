from base.AttachmentLocation import AttachmentLocationBase
from actions.AttachmentLocation import AttachmentLocationActions

class AttachmentLocation(AttachmentLocationBase, AttachmentLocationActions):
    '''
    classdocs
    '''
    def __init__(self, path='', repository=None):
        '''
        Constructor
        @param path: path
        @type path: string
        @param repository: repository
        @type repository: Link
        '''
        AttachmentLocationBase.__init__(self, path=path, repository=repository)
