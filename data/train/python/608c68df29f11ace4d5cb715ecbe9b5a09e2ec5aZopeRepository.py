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
from SequenceWrapper import SequenceWrapper
import AccessControl
import OFS
import Repository

# BBB Zope 2.12
try:
    from OFS.role import RoleManager
except ImportError:
    from AccessControl.Role import RoleManager


class ZopeRepository(
    Repository.Repository,
    RoleManager,
    OFS.SimpleItem.Item
    ):
    """The ZopeRepository class builds on the core Repository implementation
       to provide the Zope management interface and other product trappings."""

    security = AccessControl.ClassSecurityInfo()

    meta_type = 'Repository'

    manage_options=(
        ( {'label': 'Contents',    'action':'manage_main',
           'help': ('ZopeVersionControl', 'Repository-Manage.stx')},
          {'label': 'Properties', 'action':'manage_properties_form',
           'help': ('ZopeVersionControl', 'Repository-Properties.stx')},
        ) +
        RoleManager.manage_options +
        OFS.SimpleItem.Item.manage_options
        )

    security.declareProtected('View management screens', 'manage_main')
    manage_main = DTMLFile('dtml/RepositoryManageMain', globals())
    manage_main._setName('manage_main')
    manage = manage_main

    def __init__(self, id=None, title=''):
        Repository.Repository.__init__(self)
        if id is not None:
           self._setId( id )
        self.title = title

    security.declareProtected(
        'View management screens','manage_properties_form'
        )
    manage_properties_form = DTMLFile('dtml/RepositoryProperties', globals())

    security.declareProtected('Manage repositories', 'manage_edit')
    def manage_edit(self, title='', REQUEST=None):
        """Change object properties."""
        self.title = title
        if REQUEST is not None:
            message="Saved changes."
            return self.manage_properties_form(
                self, REQUEST, manage_tabs_message=message
                )

    def __getitem__(self, name):
        history = self._histories.get(name)
        if history is not None:
            return history.__of__(self)
        raise KeyError, name

    security.declarePrivate('objectIds')
    def objectIds(self, spec=None):
        return SequenceWrapper(self, self._histories.keys())

    security.declarePrivate('objectValues')
    def objectValues(self, spec=None):
        return SequenceWrapper(self, self._histories.values())

    security.declarePrivate('objectItems')
    def objectItems(self, spec=None):
        return SequenceWrapper(self, self._histories.items(), 1)

InitializeClass(ZopeRepository)



def addRepository(self, id, title='', REQUEST=None):
    """Zope object constructor function."""
    object = ZopeRepository(title=title)
    object._setId( id )
    self._setObject(id, object)
    object = self._getOb(id)
    if REQUEST is not None:
        try:    url = self.DestinationURL()
        except: url = REQUEST['URL1']
        REQUEST.RESPONSE.redirect('%s/manage_main' % url)
    return

addRepositoryForm = DTMLFile('dtml/RepositoryAddForm', globals())


constructors = (
  ('addRepositoryForm', addRepositoryForm),
  ('addRepository',     addRepository),
)
