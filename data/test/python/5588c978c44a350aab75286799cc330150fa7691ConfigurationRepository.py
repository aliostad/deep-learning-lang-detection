from core.agility.v2_0.agilitymodel.base.Item import ItemBase

class ConfigurationRepositoryBase(ItemBase):
    '''
    classdocs
    '''
    def __init__(self, repositoryProperty=list(), artifactPath=list(), repositoryType=None, artifact=list(), repositoryPath=None, readOnly=False, syncIntervalSeconds=None, artifactType=None):
        ItemBase.__init__(self)
        self._attrSpecs = getattr(self, '_attrSpecs', {})
        self._attrSpecs.update({'repositoryProperty': {'maxOccurs': 'unbounded', 'type': 'Property', 'name': 'repositoryProperty', 'minOccurs': '0', 'native': False}, 'artifactPath': {'maxOccurs': 'unbounded', 'type': 'string', 'name': 'artifactPath', 'minOccurs': '0', 'native': True}, 'repositoryType': {'type': 'string', 'name': 'repositoryType', 'minOccurs': '0', 'native': True}, 'artifact': {'maxOccurs': 'unbounded', 'type': 'Link', 'name': 'artifact', 'minOccurs': '0', 'native': False}, 'repositoryPath': {'type': 'string', 'name': 'repositoryPath', 'minOccurs': '0', 'native': True}, 'readOnly': {'type': 'boolean', 'name': 'readOnly', 'native': True}, 'syncIntervalSeconds': {'type': 'int', 'name': 'syncIntervalSeconds', 'minOccurs': '0', 'native': True}, 'artifactType': {'type': 'string', 'name': 'artifactType', 'minOccurs': '0', 'native': True}})
        self.repositoryProperty = repositoryProperty
        self.artifactPath = artifactPath
        self.repositoryType = repositoryType
        self.artifact = artifact
        self.repositoryPath = repositoryPath
        self.readOnly = readOnly
        self.syncIntervalSeconds = syncIntervalSeconds
        self.artifactType = artifactType 
