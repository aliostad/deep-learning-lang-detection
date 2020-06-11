from AccessControl.Permissions import manage_users
from Products.PageTemplates.PageTemplateFile import PageTemplateFile
from Products.PluggableAuthService import registerMultiPlugin

import plugin

manage_add_timelimit_form = PageTemplateFile('browser/add_plugin',
                            globals(), __name__='manage_add_timelimit_form' )


def manage_add_timelimit_helper( dispatcher, id, title=None, REQUEST=None ):
    """Add an timelimit Helper to the PluggableAuthentication Service."""

    sp = plugin.TimelimitHelper( id, title )
    dispatcher._setObject( sp.getId(), sp )

    if REQUEST is not None:
        REQUEST['RESPONSE'].redirect( '%s/manage_workspace'
                                      '?manage_tabs_message='
                                      'timelimitHelper+added.'
                                      % dispatcher.absolute_url() )


def register_timelimit_plugin():
    try:
        registerMultiPlugin(plugin.TimelimitHelper.meta_type)
    except RuntimeError:
        # make refresh users happy
        pass


def register_timelimit_plugin_class(context):
    context.registerClass(plugin.TimelimitHelper,
                          permission = manage_users,
                          constructors = (manage_add_timelimit_form,
                                          manage_add_timelimit_helper),
                          visibility = None,
                          icon='browser/icon.gif'
                         )
