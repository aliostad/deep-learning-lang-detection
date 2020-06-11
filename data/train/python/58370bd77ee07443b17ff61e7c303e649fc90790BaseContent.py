from Products.Archetypes import WebDAVSupport
from Products.Archetypes.BaseObject import BaseObject
from Products.Archetypes.Referenceable import Referenceable
from Products.Archetypes.ExtensibleMetadata import ExtensibleMetadata
from Products.Archetypes.interfaces.base import IBaseContent as z2IBaseContent
from Products.Archetypes.interfaces.referenceable import IReferenceable
from Products.Archetypes.interfaces.metadata import IExtensibleMetadata
from Products.Archetypes.CatalogMultiplex import CatalogMultiplex

from Acquisition import aq_base
from Acquisition import aq_get
from AccessControl import ClassSecurityInfo
from Globals import InitializeClass
from OFS.History import Historical
from Products.CMFCore import permissions
from Products.CMFCore.PortalContent import PortalContent
from OFS.PropertyManager import PropertyManager

from Products.Archetypes.interfaces import IBaseContent
from zope.interface import implements

class BaseContentMixin(CatalogMultiplex,
                       BaseObject,
                       PortalContent,
                       Historical):
    """A not-so-basic CMF Content implementation that doesn't
    include Dublin Core Metadata"""

    __implements__ = z2IBaseContent, IReferenceable, PortalContent.__implements__
    implements(IBaseContent)

    security = ClassSecurityInfo()
    manage_options = PortalContent.manage_options + Historical.manage_options

    isPrincipiaFolderish = 0
    isAnObjectManager = 0
    __dav_marshall__ = True

    security.declarePrivate('manage_afterAdd')
    def manage_afterAdd(self, item, container):
        BaseObject.manage_afterAdd(self, item, container)
        CatalogMultiplex.manage_afterAdd(self, item, container)

    security.declarePrivate('manage_afterClone')
    def manage_afterClone(self, item):
        BaseObject.manage_afterClone(self, item)
        CatalogMultiplex.manage_afterClone(self, item)

    security.declarePrivate('manage_beforeDelete')
    def manage_beforeDelete(self, item, container):
        BaseObject.manage_beforeDelete(self, item, container)
        CatalogMultiplex.manage_beforeDelete(self, item, container)

        #and reset the rename flag (set in Referenceable._notifyCopyOfCopyTo)
        self._v_cp_refs = None

    def _notifyOfCopyTo(self, container, op=0):
        """OFS.CopySupport notify
        """
        BaseObject._notifyOfCopyTo(self, container, op=op)
        PortalContent._notifyOfCopyTo(self, container, op=op)

    security.declareProtected(permissions.ModifyPortalContent, 'PUT')
    PUT = WebDAVSupport.PUT

    security.declareProtected(permissions.View, 'manage_FTPget')
    manage_FTPget = WebDAVSupport.manage_FTPget

    security.declarePrivate('manage_afterPUT')
    manage_afterPUT = WebDAVSupport.manage_afterPUT

InitializeClass(BaseContentMixin)

class BaseContent(BaseContentMixin,
                  ExtensibleMetadata,
                  PropertyManager):
    """A not-so-basic CMF Content implementation with Dublin Core
    Metadata included"""

    __implements__ = BaseContentMixin.__implements__, IExtensibleMetadata

    schema = BaseContentMixin.schema + ExtensibleMetadata.schema

    manage_options = BaseContentMixin.manage_options + \
        PropertyManager.manage_options

    def __init__(self, oid, **kwargs):
        BaseContentMixin.__init__(self, oid, **kwargs)
        ExtensibleMetadata.__init__(self)

InitializeClass(BaseContent)


BaseSchema = BaseContent.schema

__all__ = ('BaseContent', 'BaseContentMixin', 'BaseSchema', )
