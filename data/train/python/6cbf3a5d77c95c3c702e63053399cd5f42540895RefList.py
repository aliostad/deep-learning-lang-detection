
from Globals import InitializeClass
from AccessControl import ClassSecurityInfo
from AccessControl.Permissions import view_management_screens, view
from OFS.SimpleItem import SimpleItem
from Products.PageTemplates.PageTemplateFile import PageTemplateFile

#Product related imports
from Products.NaayaCore.constants import *
from managers.ref_manager import ref_manager

manage_addRefListForm = PageTemplateFile('zpt/reflist_add', globals())
def manage_addRefList(self, id='', title='', description='', REQUEST=None):
    """ """
    id = self.utSlugify(id)
    if not id: id = PREFIX_SUFIX_REFLIST % self.utGenRandomId(6)
    ob = RefList(id, title, description)
    self._setObject(id, ob)
    if REQUEST is not None:
        return self.manage_main(self, REQUEST, update_menu=1)

class RefList(SimpleItem, ref_manager):
    """ """

    meta_type = METATYPE_REFLIST
    icon = 'misc_/NaayaCore/RefList.gif'

    manage_options = (
        (
            {'label': 'Items', 'action': 'manage_items_html'},
        )
        +
        SimpleItem.manage_options
    )

    security = ClassSecurityInfo()

    def __init__(self, id, title, description):
        """ """
        self.id = id
        self.title = title
        self.description = description
        ref_manager.__dict__['__init__'](self)

    #zmi actions
    security.declareProtected(view_management_screens, 'manageProperties')
    def manageProperties(self, title='', description='', REQUEST=None):
        """ """
        self.title = title
        self.description = description
        self._p_changed = 1
        if REQUEST:
            REQUEST.RESPONSE.redirect('manage_properties_html')

    security.declareProtected(view_management_screens, 'manage_add_item')
    def manage_add_item(self, id='', title='', REQUEST=None):
        """ """
        id = self.utSlugify(id)
        if not id: id = PREFIX_SUFIX_REFLISTITEM % self.utGenRandomId(6)
        self.add_item(id, title)
        if REQUEST: REQUEST.RESPONSE.redirect('manage_items_html?save=ok')

    security.declareProtected(view_management_screens, 'manage_update_item')
    def manage_update_item(self, id='', title='', REQUEST=None):
        """ """
        self.update_item(id, title)
        if REQUEST: REQUEST.RESPONSE.redirect('manage_items_html?save=ok')

    security.declareProtected(view_management_screens, 'manage_delete_items')
    def manage_delete_items(self, ids=[], REQUEST=None):
        """ """
        self.delete_item(self.utConvertToList(ids))
        if REQUEST: REQUEST.RESPONSE.redirect('manage_items_html?save=ok')

    #zmi pages
    security.declareProtected(view_management_screens, 'manage_items_html')
    manage_items_html = PageTemplateFile('zpt/reflist_items', globals())

InitializeClass(RefList)
