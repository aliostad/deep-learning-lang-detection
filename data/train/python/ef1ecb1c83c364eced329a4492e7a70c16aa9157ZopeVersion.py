##############################################################################
#
# Copyright (c) 2001 Zope Corporation and Contributors. All Rights Reserved.
# 
# This software is subject to the provisions of the Zope Public License,
# Version 2.0 (ZPL).  A copy of the ZPL should accompany this distribution.
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY AND ALL EXPRESS OR IMPLIED
# WARRANTIES ARE DISCLAIMED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF TITLE, MERCHANTABILITY, AGAINST INFRINGEMENT, AND FITNESS
# FOR A PARTICULAR PURPOSE
# 
##############################################################################

__version__='$Revision: 1.6 $'[11:-2]

from Globals import DTMLFile, InitializeClass
import OFS, AccessControl
import Version


class ZopeVersion(
    Version.Version,
    AccessControl.Role.RoleManager,
    OFS.SimpleItem.Item
    ):
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
        AccessControl.Role.RoleManager.manage_options +
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
