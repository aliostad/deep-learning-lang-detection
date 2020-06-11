from AccessControl.Permissions import manage_users
from Products.PageTemplates.PageTemplateFile import PageTemplateFile
from Products.PluggableAuthService import registerMultiPlugin

import plugin

manage_add_oauth_form = PageTemplateFile('browser/add_plugin' , globals(), __name__='manage_add_oauth_form')


def manage_add_oauth_plugin_base( dispatcher, id, title=None, REQUEST=None ):
    """Add an oauth plugin base to the PluggableAuthentication Service."""

    sp = plugin.OauthPluginBase( id, title )
    dispatcher._setObject( sp.getId(), sp )

    if REQUEST is not None:
        REQUEST['RESPONSE'].redirect( '%s/manage_workspace'
                                      '?manage_tabs_message='
                                      'OauthPluginBase+added.'
                                      % dispatcher.absolute_url() )

def register_oauth_plugin():
    try:
        registerMultiPlugin(plugin.OauthPluginBase.meta_type)
    except RuntimeError:
        # make refresh users happy
        pass

def register_oauth_plugin_class(context):
    context.registerClass(plugin.OauthPluginBase,
                          permission = manage_users,
                          constructors = (manage_add_oauth_form,
                                          manage_add_oauth_plugin_base),
                          visibility = None,
                          icon='browser/images/oauth_listing.gif'
                         )
