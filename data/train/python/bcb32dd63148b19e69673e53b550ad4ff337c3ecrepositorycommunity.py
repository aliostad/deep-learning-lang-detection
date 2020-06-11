"""Definition of the Repository Community content type
"""

from zope.interface import implements

from Products.Archetypes import atapi
from Products.ATContentTypes.content import folder
from Products.ATContentTypes.content import schemata

# -*- Message Factory Imported Here -*-

from bungenicms.repository.interfaces import IRepositoryCommunity, IRepositoryItemBrowser
from bungenicms.repository.config import PROJECTNAME

RepositoryCommunitySchema = folder.ATFolderSchema.copy() + atapi.Schema((

    # -*- Your Archetypes field definitions here ... -*-

))

# Set storage on fields copied from ATFolderSchema, making sure
# they work well with the python bridge properties.

RepositoryCommunitySchema['title'].storage = atapi.AnnotationStorage()
RepositoryCommunitySchema['description'].storage = atapi.AnnotationStorage()

schemata.finalizeATCTSchema(
    RepositoryCommunitySchema,
    folderish=True,
    moveDiscussion=False
)


class RepositoryCommunity(folder.ATFolder):
    """Repository Community"""
    implements(IRepositoryCommunity, IRepositoryItemBrowser)

    meta_type = "RepositoryCommunity"
    schema = RepositoryCommunitySchema

    title = atapi.ATFieldProperty('title')
    description = atapi.ATFieldProperty('description')

    # -*- Your ATSchema to Python Property Bridges Here ... -*-

atapi.registerType(RepositoryCommunity, PROJECTNAME)
