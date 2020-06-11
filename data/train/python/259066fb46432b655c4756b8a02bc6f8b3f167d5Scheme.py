
from Globals import InitializeClass
from AccessControl import ClassSecurityInfo
import Products
from OFS.Folder import Folder
from Products.PageTemplates.PageTemplateFile import PageTemplateFile

from Products.NaayaCore.constants import *
import Style
import DiskFile
import DiskTemplate

manage_addSchemeForm = PageTemplateFile('zpt/scheme_add', globals())
def manage_addScheme(self, id='', title='', REQUEST=None):
    """ """
    ob = Scheme(id, title)
    self._setObject(id, ob)
    if REQUEST is not None:
        return self.manage_main(self, REQUEST, update_menu=1)

class Scheme(Folder):
    """ """

    meta_type = METATYPE_SCHEME
    icon = 'misc_/NaayaCore/Scheme.gif'

    manage_options = (
        Folder.manage_options
    )

    security = ClassSecurityInfo()

    meta_types = (
        {'name': METATYPE_STYLE, 'action': 'manage_addStyle_html', 'permission': PERMISSION_ADD_NAAYACORE_TOOL },
        {'name': METATYPE_DISKFILE, 'action': 'manage_addDiskFile_html', 'permission': PERMISSION_ADD_NAAYACORE_TOOL },
        {'name': METATYPE_DISKTEMPLATE, 'action': 'manage_addDiskTemplate_html', 'permission': PERMISSION_ADD_NAAYACORE_TOOL },
    )
    def all_meta_types(self, interfaces=None):
        """ """
        y = []
        additional_meta_types = ['Image', 'File']
        for x in Products.meta_types:
            if x['name'] in additional_meta_types:
                y.append(x)
        y.extend(self.meta_types)
        return y

    #constructors
    manage_addStyle_html = Style.manage_addStyle_html
    manage_addStyle = Style.manage_addStyle
    manage_addDiskFile_html = DiskFile.manage_addDiskFile_html
    manage_addDiskFile = DiskFile.manage_addDiskFile
    manage_addDiskTemplate_html = DiskTemplate.manage_addDiskTemplate_html
    manage_addDiskTemplate = DiskTemplate.manage_addDiskTemplate

    def __init__(self, id, title):
        """ """
        self.id = id
        self.title = title

InitializeClass(Scheme)
