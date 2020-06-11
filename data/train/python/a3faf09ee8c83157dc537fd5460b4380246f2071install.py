from AccessControl.Permissions import manage_users
from Products.PageTemplates.PageTemplateFile import PageTemplateFile
from Products.PluggableAuthService import registerMultiPlugin

import plugin

manage_add_sqlusermanager_form = PageTemplateFile('browser/add_plugin',
                            globals(), __name__='manage_add_sqlusermanager_form' )


def manage_add_sqlusermanager_helper( dispatcher, id, title=None, REQUEST=None ):
    """Add an sqlusermanager Helper to the PluggableAuthentication Service."""

    sp = plugin.SqlusermanagerHelper( id, title )
    dispatcher._setObject( sp.getId(), sp )

    if REQUEST is not None:
        REQUEST['RESPONSE'].redirect( '%s/manage_workspace'
                                      '?manage_tabs_message='
                                      'sqlusermanagerHelper+added.'
                                      % dispatcher.absolute_url() )


def register_sqlusermanager_plugin():
    try:
        registerMultiPlugin(plugin.SqlusermanagerHelper.meta_type)
    except RuntimeError:
        # make refresh users happy
        pass


def register_sqlusermanager_plugin_class(context):
    context.registerClass(plugin.SqlusermanagerHelper,
                          permission = manage_users,
                          constructors = (manage_add_sqlusermanager_form,
                                          manage_add_sqlusermanager_helper),
                          visibility = None,
                          icon='browser/icon.gif'
                         )
