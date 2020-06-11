from core.agility.v2_0.agilitymodel.base.ConfigurationRepository import ConfigurationRepositoryBase
from core.agility.v2_0.agilitymodel.actions.ConfigurationRepository import ConfigurationRepositoryActions

class ConfigurationRepository(ConfigurationRepositoryBase, ConfigurationRepositoryActions):
    '''
    classdocs
    '''
    def __init__(self, repositoryProperty=list(), artifactPath=list(), repositoryType=None, artifact=list(), repositoryPath=None, readOnly=False, syncIntervalSeconds=None, artifactType=None):
        '''
        Constructor
        @param repositoryProperty: repositoryProperty minOccurs=0 maxOccurs=unbounded
        @type repositoryProperty: Property
        @param artifactPath: artifactPath minOccurs=0 maxOccurs=unbounded
        @type artifactPath: string
        @param repositoryType: repositoryType minOccurs=0
        @type repositoryType: string
        @param artifact: artifact minOccurs=0 maxOccurs=unbounded
        @type artifact: Link
        @param repositoryPath: repositoryPath minOccurs=0
        @type repositoryPath: string
        @param readOnly: readOnly
        @type readOnly: boolean
        @param syncIntervalSeconds: syncIntervalSeconds minOccurs=0
        @type syncIntervalSeconds: int
        @param artifactType: artifactType minOccurs=0
        @type artifactType: string
        '''
        ConfigurationRepositoryBase.__init__(self, repositoryProperty=repositoryProperty, artifactPath=artifactPath, repositoryType=repositoryType, artifact=artifact, repositoryPath=repositoryPath, readOnly=readOnly, syncIntervalSeconds=syncIntervalSeconds, artifactType=artifactType)
