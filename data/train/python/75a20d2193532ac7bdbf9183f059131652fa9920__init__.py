
# zope
from AccessControl.Permissions import manage_users as ManageUsers

# cmf
from Products.PluggableAuthService.PluggableAuthService import \
     registerMultiPlugin

from anz.casclient.casclient import AnzCASClient, \
     manage_addAnzCASClient, addAnzCASClientForm

# register plugins with pas
try:
    registerMultiPlugin( AnzCASClient.meta_type )
except RuntimeError:
    # make refresh users happy
    pass

def initialize( context ):
    context.registerClass( AnzCASClient,
                           permission=ManageUsers,
                           constructors=( addAnzCASClientForm,
                                          manage_addAnzCASClient
                                          ),
                           icon='www/anz_casclient.png',
                           visibility=None
                           )
