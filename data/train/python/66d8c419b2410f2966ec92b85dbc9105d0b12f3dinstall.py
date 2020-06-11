from AccessControl.Permissions import manage_users
from Products.PageTemplates.PageTemplateFile import PageTemplateFile
from Products.PluggableAuthService import registerMultiPlugin

import plugin

manage_add_athensda_form = PageTemplateFile('browser/add_plugin',
                            globals(), __name__='manage_add_athensda_form' )


def manage_add_athensda_helper( dispatcher, id, title=None, REQUEST=None ):
    """Add an athensda Helper to the PluggableAuthentication Service."""

    sp = plugin.AthensdaHelper( id, title )
    dispatcher._setObject( sp.getId(), sp )

    if REQUEST is not None:
        REQUEST['RESPONSE'].redirect( '%s/manage_workspace'
                                      '?manage_tabs_message='
                                      'athensdaHelper+added.'
                                      % dispatcher.absolute_url() )


def register_athensda_plugin():
    try:
        registerMultiPlugin(plugin.AthensdaHelper.meta_type)
    except RuntimeError:
        # make refresh users happy
        pass


def register_athensda_plugin_class(context):
    context.registerClass(plugin.AthensdaHelper,
                          permission = manage_users,
                          constructors = (manage_add_athensda_form,
                                          manage_add_athensda_helper),
                          visibility = None,
                          icon='browser/icon.gif'
                         )
