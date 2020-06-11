# -*- coding: utf-8 -*-
# vim: sw=4 ts=4 fenc=utf-8 et
# ==============================================================================
# Copyright © 2010 UfSoft.org - Pedro Algarvio <ufs@ufsoft.org>
#
# License: BSD - Please view the LICENSE file for additional information.
# ==============================================================================

from ilog.views import account, admin, base, networks
from ilog.views.admin import options
from ilog.views.admin.manage import (users, groups, networks as admin_networks,
                                     channels, bots)

all_views = {
    # Main Handler
    'index'             : base.index,

    # Account Handlers
    'account.rpx'           : account.rpx_post,
    'account.login'         : account.login,
    'account.logout'        : account.logout,
    'account.delete'        : account.delete,
    'account.profile'       : account.profile,
    'account.register'      : account.register,
    'account.activate'      : account.activate_account,
    'account.dashboard'     : account.dashboard,
    'account.rpx_providers' : account.rpx_providers_post,

    # Network Handlers
    'network.index'     : networks.index,
    'network.channels'  : networks.channels,

    # Channel Handlers
    'channel.index'     : '',
    'channel.browse'    : '',

    # Administration
    'admin.index'                   : admin.index,
    'admin.manage.groups'           : groups.list,
    'admin.manage.groups.new'       : groups.edit,
    'admin.manage.groups.edit'      : groups.edit,
    'admin.manage.groups.delete'    : groups.delete,

    'admin.manage.users'            : users.list,
    'admin.manage.users.new'        : users.edit,
    'admin.manage.users.edit'       : users.edit,
    'admin.manage.users.delete'     : users.delete,

    'admin.manage.networks'         : admin_networks.list,
    'admin.manage.networks.new'     : admin_networks.edit,
    'admin.manage.networks.edit'    : admin_networks.edit,
    'admin.manage.networks.delete'  : admin_networks.delete,

    'admin.manage.bots'             : users.list,
    'admin.manage.bots.new'         : users.edit,
    'admin.manage.bots.edit'        : users.edit,
    'admin.manage.bots.delete'      : users.delete,

    'admin.options.basic'           : options.basic_options,
    'admin.options.advanced'        : options.advanced_options,
    'admin.options.rpxnow'          : options.rpxnow_options,
    'admin.options.gravatar'        : options.gravatar_options,
    'admin.options.email'           : options.email_options,
    'admin.options.cache'           : options.cache_options,
}
