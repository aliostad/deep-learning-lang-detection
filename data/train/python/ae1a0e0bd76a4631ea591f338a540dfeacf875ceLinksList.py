
from zope.interface import implements
from Globals import InitializeClass
from AccessControl import ClassSecurityInfo
from AccessControl.Permissions import view_management_screens, view
from OFS.SimpleItem import SimpleItem
from Products.PageTemplates.PageTemplateFile import PageTemplateFile

#Product related imports
from Products.NaayaCore.interfaces import ILinksList
from Products.NaayaCore.constants import *
from managers.links_manager import links_manager

manage_addLinksListForm = PageTemplateFile('zpt/linkslist_add', globals())
def manage_addLinksList(self, id='', title='', portlet='', REQUEST=None):
    """ """
    id = self.utSlugify(id)
    if not id: id = PREFIX_SUFIX_LINKSLIST % self.utGenRandomId(6)
    ob = LinksList(id, title)
    self._setObject(id, ob)
    if portlet:
        self.create_portlet_for_linkslist(self._getOb(id))
    if REQUEST is not None:
        return self.manage_main(self, REQUEST, update_menu=1)

class LinksList(SimpleItem, links_manager):
    """ """

    implements(ILinksList)

    meta_type = METATYPE_LINKSLIST
    icon = 'misc_/NaayaCore/LinksList.gif'

    manage_options = (
        (
            {'label': 'Links', 'action': 'manage_links_html'},
        )
        +
        SimpleItem.manage_options
    )

    security = ClassSecurityInfo()

    def __init__(self, id, title):
        """ """
        self.id = id
        self.title = title
        links_manager.__dict__['__init__'](self)

    #zmi actions
    security.declareProtected(view_management_screens, 'manageProperties')
    def manageProperties(self, title='', REQUEST=None):
        """ """
        self.title = title
        self._p_changed = 1
        if REQUEST:
            REQUEST.RESPONSE.redirect('manage_properties_html')

    security.declareProtected(view_management_screens, 'manage_add_link_item')
    def manage_add_link_item(self, id='', title='', description='', url='', relative='', permission='', order='', REQUEST=None):
        """ """
        if relative: relative = 1
        else: relative = 0
        try: order = abs(int(order))
        except: order = 0
        self.add_link_item(self.utGenRandomId(), title, description, url, relative, permission, order)
        if REQUEST: REQUEST.RESPONSE.redirect('manage_links_html?save=ok')

    security.declareProtected(view_management_screens, 'manage_update_link_item')
    def manage_update_link_item(self, id='', title='', description='', url='', relative='', permission='', order='', REQUEST=None):
        """ """
        if relative: relative = 1
        else: relative = 0
        try: order = abs(int(order))
        except: order = 0
        self.update_link_item(id, title, description, url, relative, permission, order)
        if REQUEST: REQUEST.RESPONSE.redirect('manage_links_html?save=ok')

    security.declareProtected(view_management_screens, 'manage_delete_links')
    def manage_delete_links(self, ids=[], REQUEST=None):
        """ """
        self.delete_link_item(self.utConvertToList(ids))
        if REQUEST: REQUEST.RESPONSE.redirect('manage_links_html?save=ok')

    #zmi pages
    security.declareProtected(view_management_screens, 'manage_links_html')
    manage_links_html = PageTemplateFile('zpt/linkslist_links', globals())

InitializeClass(LinksList)
