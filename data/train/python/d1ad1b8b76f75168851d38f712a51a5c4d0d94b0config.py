"""Common configuration constants
"""
from AccessControl import ModuleSecurityInfo
from Products.CMFCore.permissions import setDefaultRoles

PROJECTNAME = 'raptus.article.core'

security = ModuleSecurityInfo('raptus.article.core.config')

security.declarePublic('ADD_PERMISSION')
ADD_PERMISSION = 'raptus.article: Add Article'
setDefaultRoles(ADD_PERMISSION, ('Manager','Contributor',))

security.declarePublic('MANAGE_PERMISSION')
MANAGE_PERMISSION = 'raptus.article: Manage Components'
setDefaultRoles(MANAGE_PERMISSION, ('Manager','Editor','Owner',))
