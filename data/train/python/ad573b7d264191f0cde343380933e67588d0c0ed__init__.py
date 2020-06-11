from AccessControl.Permissions import manage_users as ManageUsers
from Products.PluggableAuthService.PluggableAuthService import \
    registerMultiPlugin

from pmr2.tempauth import plugin


registerMultiPlugin(plugin.TemporaryAuthPlugin.meta_type)

def initialize(context):
    context.registerClass(plugin.TemporaryAuthPlugin,
        permission=ManageUsers,
        constructors=(
            plugin.manage_addTemporaryAuthPlugin,
            plugin.addTemporaryAuthPlugin,
        ),
        visibility=None,
    )
