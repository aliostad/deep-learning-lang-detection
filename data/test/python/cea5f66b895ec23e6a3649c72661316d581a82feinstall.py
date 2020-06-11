
from AccessControl.Permissions import manage_users
from Products.PageTemplates.PageTemplateFile import PageTemplateFile
from Products.PluggableAuthService import registerMultiPlugin

import plugin

manage_add_aspxauthplugin_form = PageTemplateFile('browser/add_plugin',
                            globals(), __name__='manage_add_aspxauthplugin_form' )


def manage_add_aspxauthplugin( dispatcher, id, title=None, REQUEST=None ):
    """Add an aspxauthplugin Helper to the PluggableAuthentication Service."""

    sp = plugin.ASPXAuthPlugin( id, title )
    dispatcher._setObject( sp.getId(), sp )

    if REQUEST is not None:
        REQUEST['RESPONSE'].redirect( '%s/manage_workspace'
                                      '?manage_tabs_message='
                                      'aspxauthpluginHelper+added.'
                                      % dispatcher.absolute_url() )


def register_aspxauthplugin_plugin():
    try:
        registerMultiPlugin(plugin.ASPXAuthPlugin.meta_type)
    except RuntimeError:
        # make refresh users happy
        pass


def register_aspxauthplugin_plugin_class(context):
    context.registerClass(plugin.ASPXAuthPlugin,
                          permission = manage_users,
                          constructors = (manage_add_aspxauthplugin_form,
                                          manage_add_aspxauthplugin),
                          visibility = None,
                          icon='browser/icon.gif'
                         )
