from AccessControl.Permissions import manage_users as ManageUsers
from .plugins import *
from Products.PluggableAuthService import registerMultiPlugin


registerMultiPlugin('Password File User & Role Manager')


def initialize(context):

    context.registerClass( PasswordFileUserRoleManager
                         , permission=ManageUsers
                         , constructors=(
                            manage_addPasswordFileUserRoleManagerForm,
                            addPasswordFileUserRoleManager, )
                         , icon='www/icon.gif'
                         )
