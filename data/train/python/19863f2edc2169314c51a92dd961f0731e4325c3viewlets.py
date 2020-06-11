# -*- coding: utf-8 -*-
from plone import api
from plone.app.layout.viewlets.common import ViewletBase
from zope.component import getMultiAdapter


class TeaserPortletsViewlet(ViewletBase):

    name = 'Teaser portlets'
    manage_view = '@@manage-teaserportlets'

    @property
    def display(self):
        return True

    def update(self):
        if not self.display:
            self.canManagePortlets = False
            return
        context_state = getMultiAdapter(
            (self.context, self.request),
            name=u'plone_context_state'
        )
        self.manageUrl = '%s/%s' % (context_state.view_url(), self.manage_view)
        # This is the way it's done in plone.app.portlets.manager, so we'll
        # do the same
        self.canManagePortlets = api.user.has_permission(
            permission='Portlets: Manage portlets',
            obj=self.context
        )
