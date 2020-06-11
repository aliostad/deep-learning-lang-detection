from core.agility.v3_0.agilitymodel.base.AttachmentLocation import AttachmentLocationBase
from core.agility.v3_0.agilitymodel.actions.AttachmentLocation import AttachmentLocationActions

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
