from core.agility.v2_0.agilitymodel.base.Repository import RepositoryBase
from core.agility.v2_0.agilitymodel.actions.Repository import RepositoryActions

class Repository(RepositoryBase, RepositoryActions):
    '''
    classdocs
    '''
    def __init__(self, repositoryType=None, locations=list(), usage=list(), path=None, properties=list(), cloud=None, size=None):
        '''
        Constructor
        @param repositoryType: repositoryType minOccurs=0
        @type repositoryType: string
        @param locations: locations minOccurs=0 maxOccurs=unbounded
        @type locations: string
        @param usage: usage minOccurs=0 maxOccurs=unbounded
        @type usage: RepositoryUsage
        @param path: path minOccurs=0
        @type path: string
        @param properties: properties minOccurs=0 maxOccurs=unbounded
        @type properties: Property
        @param cloud: cloud minOccurs=0
        @type cloud: Link
        @param size: size minOccurs=0
        @type size: long
        '''
        RepositoryBase.__init__(self, repositoryType=repositoryType, locations=locations, usage=usage, path=path, properties=properties, cloud=cloud, size=size)
