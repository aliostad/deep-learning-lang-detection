from core.agility.common.AgilityModelBase import AgilityModelBase


class AttachmentLocationBase(AgilityModelBase):
    '''
    classdocs
    '''
    def __init__(self, path='', repository=None):
        AgilityModelBase.__init__(self)
        self._attrSpecs = getattr(self, '_attrSpecs', {})
        self._attrSpecs.update({'path': {'type': 'string', 'name': 'path', 'native': True}, 'repository': {'type': 'Link', 'name': 'repository', 'native': False}})
        self.path = path
        self.repository = repository 
