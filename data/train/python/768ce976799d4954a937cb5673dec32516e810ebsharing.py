from zope.interface import implements, Interface
from Products.CMFPlone import PloneMessageFactory as _

try:
    from plone.app.workflow.interfaces import ISharingPageRole as interfaceToImplement
except ImportError:
    # Fail nicely, this version of Plone doesn't know anything about @@sharing page roles.
    class IDoNothing(Interface):
        pass
    interfaceToImplement = IDoNothing

class PortletManagerRole(object):
    implements(interfaceToImplement)
    title = _(u"title_manage_portlets", default=u"Can manage portlets")
    required_permission = 'Manage portal content'

class CollectionManagerRole(object):
    implements(interfaceToImplement)
    title = _(u"title_manage_collections", default=u"Can manage collections")
    required_permission = 'Manage portal content'

class RestrictedContentManagerRole(object):
    implements(interfaceToImplement)
    title = _(u"title_manage_restricted_content", default=u"Can manage restricted content")
    required_permission = 'Manage portal content'
