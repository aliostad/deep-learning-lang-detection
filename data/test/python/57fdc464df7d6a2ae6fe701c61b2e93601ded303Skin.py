
from Globals import InitializeClass
from AccessControl import ClassSecurityInfo
from OFS.Folder import Folder
from Products.PageTemplates.PageTemplateFile import PageTemplateFile

from Products.NaayaCore.constants import *
import Scheme
import Template
import Style
import DiskFile
import DiskTemplate


manage_addSkinForm = PageTemplateFile('zpt/skin_add', globals())
def manage_addSkin(self, id='', title='', content=None, REQUEST=None):
    """ """
    if content is None or content == '':
        ob = Skin(id, title)
        self._setObject(id, ob)
        if content == '':
            #create default empty templates
            self._getOb(id).createSkinFiles()
    else:
        self.manage_clone(self._getOb(content), id)
        ob = self._getOb(id)
        ob.title = title
        ob._p_changed = 1
    if REQUEST is not None:
        return self.manage_main(self, REQUEST, update_menu=1)

class Skin(Folder):
    """ """

    meta_type = METATYPE_SKIN
    icon = 'misc_/NaayaCore/Skin.gif'

    manage_options = (
        Folder.manage_options
    )

    security = ClassSecurityInfo()

    meta_types = (
        {'name': METATYPE_SCHEME, 'action': 'manage_addSchemeForm', 'permission': PERMISSION_ADD_NAAYACORE_TOOL},
        {'name': METATYPE_TEMPLATE, 'action': 'manage_addTemplateForm', 'permission': PERMISSION_ADD_NAAYACORE_TOOL},
        {'name': METATYPE_STYLE, 'action': 'manage_addStyle_html', 'permission': PERMISSION_ADD_NAAYACORE_TOOL },
        {'name': METATYPE_DISKFILE, 'action': 'manage_addDiskFile_html', 'permission': PERMISSION_ADD_NAAYACORE_TOOL },
        {'name': METATYPE_DISKTEMPLATE, 'action': 'manage_addDiskTemplate_html', 'permission': PERMISSION_ADD_NAAYACORE_TOOL },
        {'name': 'Image', 'action': 'manage_addProduct/OFSP/imageAdd', 'permission': 'Add Documents, Images, and Files' },
        {'name': 'File', 'action': 'manage_addProduct/OFSP/fileAdd', 'permission': 'Add Documents, Images, and Files' },
        {'name': 'Folder', 'action': 'manage_addProduct/OFSP/folderAdd', 'permission': 'Add Folders' },
    )
    all_meta_types = meta_types

    #constructors
    manage_addStyle_html = Style.manage_addStyle_html
    manage_addStyle = Style.manage_addStyle
    manage_addDiskFile_html = DiskFile.manage_addDiskFile_html
    manage_addDiskFile = DiskFile.manage_addDiskFile
    manage_addDiskTemplate_html = DiskTemplate.manage_addDiskTemplate_html
    manage_addDiskTemplate = DiskTemplate.manage_addDiskTemplate
    manage_addSchemeForm = Scheme.manage_addSchemeForm
    manage_addScheme = Scheme.manage_addScheme
    manage_addTemplateForm = Template.manage_addTemplateForm
    manage_addTemplate = Template.manage_addTemplate

    def __init__(self, id, title):
        """ """
        self.id = id
        self.title = title

    security.declarePrivate('createSkinFiles')
    def createSkinFiles(self):
        #Creates the default template files with empty content
        self.manage_addTemplate('site_header', 'Portal standard HTML header')
        self.manage_addTemplate('site_footer', 'Portal standard HTML footer')
        self.manage_addTemplate('portlet_left_macro', 'Macro for left portlets')
        self.manage_addTemplate('portlet_center_macro', 'Macro for center portlets')
        self.manage_addTemplate('portlet_right_macro', 'Macro for right portlets')

    #api
    def getSchemes(self): return self.objectValues(METATYPE_SCHEME)
    def getTemplateById(self, p_id): return self._getOb(p_id)

InitializeClass(Skin)
