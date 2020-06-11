from zope import interface
from zope import component
from zope import annotation
from zope.deprecation import deprecated
from persistent.dict import PersistentDict

from gu.repository.content.interfaces import IRepositoryMetadata
#

ANNO_KEY = 'gu.repository'

#


#
deprecated('RepositoryMetadata', 'Not useful anymore')
class RepositoryMetadata(PersistentDict):
    interface.implements(IRepositoryMetadata)
    component.adapts(annotation.IAttributeAnnotatable)

#
deprecated('RepositoryMetadataAdapter', 'Not useful anymore')
RepositoryMetadataAdapter = annotation.factory(RepositoryMetadata, key=ANNO_KEY)
