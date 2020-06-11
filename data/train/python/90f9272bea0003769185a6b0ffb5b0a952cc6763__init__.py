# -*- coding: utf-8 -*-
# Copyright (c) 2008-2013 Infrae. All rights reserved.
# See also LICENSE.txt
# $Id$

from AccessControl.Permissions import manage_users as ManageUsers
from Products.PluggableAuthService.PluggableAuthService import registerMultiPlugin
from plugins import membership
registerMultiPlugin(membership.MembershipPlugin.meta_type)


def initialize(context):
    context.registerClass(membership.MembershipPlugin,
                          permission=ManageUsers,
                          constructors=
                          (membership.manage_addMembershipPluginForm,
                           membership.manage_addMembershipPlugin),
                          visibility=None,
                          icon="www/members.png")

