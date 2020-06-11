##############################################################################
#
# Copyright (c) 2001 Zope Foundation and Contributors.
#
# This software is subject to the provisions of the Zope Public License,
# Version 2.1 (ZPL).  A copy of the ZPL should accompany this distribution.
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY AND ALL EXPRESS OR IMPLIED
# WARRANTIES ARE DISCLAIMED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF TITLE, MERCHANTABILITY, AGAINST INFRINGEMENT, AND FITNESS
# FOR A PARTICULAR PURPOSE
#
##############################################################################

from App.class_init import default__class_init__ as InitializeClass
from App.special_dtml import DTMLFile
import OFS, AccessControl
import Version

# BBB Zope 2.12
try:
    from OFS.role import RoleManager
except ImportError:
    from AccessControl.Role import RoleManager


class ZopeVersion(Version.Version, RoleManager, OFS.SimpleItem.Item):
    """The ZopeVersion class builds on the core Version class to provide
       the Zope management interface and other product trappings."""

    security = AccessControl.ClassSecurityInfo()
    security.setDefaultAccess('deny')

    meta_type = 'Version'

    manage_options=(
        ( {'label': 'Information',  'action':'manage_main',
           'help': ('ZopeVersionControl', 'Version-Manage.stx')},
          {'label': 'Properties', 'action':'manage_properties_form',
           'help': ('ZopeVersionControl', 'Version-Properties.stx')},
        ) +
        RoleManager.manage_options +
        OFS.SimpleItem.Item.manage_options
        )

    icon='misc_/ZopeVersionControl/Version.gif'

    security.declareProtected('View management screens', 'manage_main')
    manage_main = DTMLFile('dtml/VersionManageMain', globals())
    manage_main._setName('manage_main')
    manage = manage_main

    security.declareProtected(
        'View management screens', 'manage_properties_form'
        )
    manage_properties_form = DTMLFile('dtml/VersionProperties', globals())

    security.declareProtected('Manage repositories', 'manage_edit')
    def manage_edit(self, REQUEST=None):
        """Change object properties."""
        if REQUEST is not None:
            message="Saved changes."
            return self.manage_properties_form(
                self, REQUEST, manage_tabs_message=message

                )

InitializeClass(ZopeVersion)
