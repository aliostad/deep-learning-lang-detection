"""Definition of the Document Repository content type
"""

from zope.interface import implements

from Products.Archetypes import atapi
from Products.ATContentTypes.content import folder
from Products.ATContentTypes.content import schemata

# -*- Message Factory Imported Here -*-

from bungenicms.repository.interfaces import IDocumentRepository, IRepositoryItemBrowser
from bungenicms.repository.config import PROJECTNAME

DocumentRepositorySchema = folder.ATFolderSchema.copy() + atapi.Schema((

    # -*- Your Archetypes field definitions here ... -*-

))

# Set storage on fields copied from ATFolderSchema, making sure
# they work well with the python bridge properties.

DocumentRepositorySchema['title'].storage = atapi.AnnotationStorage()
DocumentRepositorySchema['description'].storage = atapi.AnnotationStorage()

schemata.finalizeATCTSchema(
    DocumentRepositorySchema,
    folderish=True,
    moveDiscussion=False
)


class DocumentRepository(folder.ATFolder):
    """Document Repository"""
    implements(IDocumentRepository, IRepositoryItemBrowser)

    meta_type = "DocumentRepository"
    schema = DocumentRepositorySchema

    title = atapi.ATFieldProperty('title')
    description = atapi.ATFieldProperty('description')

    # -*- Your ATSchema to Python Property Bridges Here ... -*-

atapi.registerType(DocumentRepository, PROJECTNAME)
