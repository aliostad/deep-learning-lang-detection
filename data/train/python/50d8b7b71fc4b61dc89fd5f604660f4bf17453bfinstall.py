from collective.openxchange.pas import plugin
from AccessControl.Permissions import manage_users
from Products.PageTemplates.PageTemplateFile import PageTemplateFile
from Products.PluggableAuthService import registerMultiPlugin

manage_add_openxchange_form = PageTemplateFile('../browser/add_plugin',
                    globals(), __name__='manage_add_openxchange_form' )


def manage_add_openxchange_helper(dispatcher, id, title=None, REQUEST=None):
    """Add an sqlalchemy Helper to the PluggableAuthentication Service."""

    sp = plugin.OpenXChangeHelper(id, title)

    dispatcher._setObject( sp.getId(), sp)

    if REQUEST is not None:
        REQUEST['RESPONSE'].redirect( '%s/manage_workspace'
                                      '?manage_tabs_message='
                                      'OpenXChangeHelper+added.'
                                      % dispatcher.absolute_url())


def register_plugin():
    try:
        registerMultiPlugin(plugin.OpenXChangeHelper.meta_type)
    except RuntimeError:
        pass


def register_plugin_class(context):
    context.registerClass(plugin.OpenXChangeHelper,
                          permission = manage_users,
                          constructors = (manage_add_openxchange_form,
                                          manage_add_openxchange_helper),
                          visibility = None,
                          icon='browser/icon.gif'
                         )
