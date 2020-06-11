from Products.Archetypes import WebDAVSupport
from Products.Archetypes.BaseObject import BaseObject
from Products.Archetypes.ExtensibleMetadata import ExtensibleMetadata
from Products.Archetypes.interfaces import IBaseContent
from Products.Archetypes.interfaces import IReferenceable
from Products.Archetypes.interfaces import IExtensibleMetadata
from Products.Archetypes.CatalogMultiplex import CatalogMultiplex

from AccessControl import ClassSecurityInfo
from App.class_init import InitializeClass
from OFS.History import Historical
from Products.CMFCore import permissions
from Products.CMFCore.PortalContent import PortalContent
from OFS.PropertyManager import PropertyManager

from zope.interface import implementer

CONTENT_MANAGE_OPTIONS = (
    {'action': 'manage_change_history_page', 'label': 'History'},
    {'action': 'view', 'label': 'View'},
    {'action': 'manage_interfaces', 'label': 'Interfaces'},
)


@implementer(IBaseContent, IReferenceable)
class BaseContentMixin(CatalogMultiplex,
                       BaseObject,
                       PortalContent,
                       Historical):
    """A not-so-basic CMF Content implementation that doesn't
    include Dublin Core Metadata"""

    security = ClassSecurityInfo()
    manage_options = CONTENT_MANAGE_OPTIONS

    isPrincipiaFolderish = 0
    isAnObjectManager = 0
    __dav_marshall__ = True

    security.declarePrivate('manage_afterAdd')

    def manage_afterAdd(self, item, container):
        BaseObject.manage_afterAdd(self, item, container)

    security.declarePrivate('manage_afterClone')

    def manage_afterClone(self, item):
        BaseObject.manage_afterClone(self, item)

    security.declarePrivate('manage_beforeDelete')

    def manage_beforeDelete(self, item, container):
        BaseObject.manage_beforeDelete(self, item, container)
        # and reset the rename flag (set in Referenceable._notifyCopyOfCopyTo)
        self._v_cp_refs = None

    def _notifyOfCopyTo(self, container, op=0):
        # OFS.CopySupport notify
        BaseObject._notifyOfCopyTo(self, container, op=op)
        # keep reference info internally when op == 1 (move)
        # because in those cases we need to keep refs
        if op == 1:
            self._v_cp_refs = 1

    security.declareProtected(permissions.ModifyPortalContent, 'PUT')
    PUT = WebDAVSupport.PUT

    security.declareProtected(permissions.View, 'manage_FTPget')
    manage_FTPget = WebDAVSupport.manage_FTPget

    security.declarePrivate('manage_afterPUT')
    manage_afterPUT = WebDAVSupport.manage_afterPUT

InitializeClass(BaseContentMixin)


@implementer(IBaseContent, IReferenceable, IExtensibleMetadata)
class BaseContent(BaseContentMixin,
                  ExtensibleMetadata,
                  PropertyManager):
    """A not-so-basic CMF Content implementation with Dublin Core
    Metadata included"""

    schema = BaseContentMixin.schema + ExtensibleMetadata.schema

    def __init__(self, oid, **kwargs):
        BaseContentMixin.__init__(self, oid, **kwargs)
        ExtensibleMetadata.__init__(self)

InitializeClass(BaseContent)


BaseSchema = BaseContent.schema

__all__ = ('BaseContent', 'BaseContentMixin', 'BaseSchema', )
