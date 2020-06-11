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
import VersionHistory

# BBB Zope 2.12
try:
    from OFS.role import RoleManager
except ImportError:
    from AccessControl.Role import RoleManager


class ZopeVersionHistory(
    VersionHistory.VersionHistory,
    RoleManager,
    OFS.SimpleItem.Item,
    ):
    """The ZopeVersionHistory build on the core VersionHistory class to
       provide the Zope management interface and other product trappings."""

    security = AccessControl.ClassSecurityInfo()
    security.setDefaultAccess('deny')

    meta_type = 'Version History'

    manage_options=(
        ( {'label': 'Contents',    'action':'manage_main',
           'help': ('ZopeVersionControl', 'VersionHistory-Manage.stx')},
          {'label': 'Properties', 'action':'manage_properties_form',
           'help': ('ZopeVersionControl', 'VersionHistory-Properties.stx')},
        ) +
        RoleManager.manage_options +
        OFS.SimpleItem.Item.manage_options
        )

    icon='misc_/ZopeVersionControl/VersionHistory.gif'

    security.declareProtected('View management screens', 'manage_main')
    manage_main = DTMLFile('dtml/VersionHistoryManageMain', globals())
    manage_main._setName('manage_main')
    manage = manage_main

    security.declareProtected(
        'View management screens', 'manage_properties_form'
        )
    manage_properties_form = DTMLFile(
        'dtml/VersionHistoryProperties', globals()
        )

    security.declareProtected('Manage repositories', 'manage_edit')
    def manage_edit(self, REQUEST=None):
        """Change object properties."""
        if REQUEST is not None:
            message="Saved changes."
            return self.manage_properties_form(
                self, REQUEST, manage_tabs_message=message
                )

    def __getitem__(self, name):
        activity = self._branches.get(name)
        if activity is not None:
            return activity.__of__(self)
        raise KeyError, name

    security.declarePrivate('objectIds')
    def objectIds(self, spec=None):
        return self._branches.keys()

    security.declarePrivate('objectValues')
    def objectValues(self, spec=None):
        return self._branches.values()

    security.declarePrivate('objectItems')
    def objectItems(self, spec=None):
        return self._branches.items()

InitializeClass(ZopeVersionHistory)


