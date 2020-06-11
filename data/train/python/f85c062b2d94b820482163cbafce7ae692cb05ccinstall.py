from AccessControl.Permissions import manage_users
from Products.PageTemplates.PageTemplateFile import PageTemplateFile
from Products.PluggableAuthService import registerMultiPlugin

import plugin

manage_add_osiris_form = PageTemplateFile('browser/add_plugin',
                            globals(), __name__='manage_add_osiris_form' )


def manage_add_osiris_helper( dispatcher, id, title=None, REQUEST=None ):
    """Add an osiris Helper to the PluggableAuthentication Service."""

    sp = plugin.OsirisHelper( id, title )
    dispatcher._setObject( sp.getId(), sp )

    if REQUEST is not None:
        REQUEST['RESPONSE'].redirect( '%s/manage_workspace'
                                      '?manage_tabs_message='
                                      'osirisHelper+added.'
                                      % dispatcher.absolute_url() )


def register_osiris_plugin():
    try:
        registerMultiPlugin(plugin.OsirisHelper.meta_type)
    except RuntimeError:
        # make refresh users happy
        pass


def register_osiris_plugin_class(context):
    context.registerClass(plugin.OsirisHelper,
                          permission = manage_users,
                          constructors = (manage_add_osiris_form,
                                          manage_add_osiris_helper),
                          visibility = None,
                          icon='browser/icon.gif'
                         )
