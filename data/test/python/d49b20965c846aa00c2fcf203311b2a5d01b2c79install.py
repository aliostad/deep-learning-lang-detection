from AccessControl.Permissions import manage_users
from Products.PageTemplates.PageTemplateFile import PageTemplateFile
from Products.PluggableAuthService import registerMultiPlugin

import plugin

manage_add_wsse_form = PageTemplateFile('browser/add_plugin',
                            globals(), __name__='manage_add_wsse_form' )


def manage_add_wsse_helper(dispatcher, id, title=None, REQUEST=None):
    """Add an WSSE Helper to the PluggableAuthentication Service."""

    sp = plugin.WsseHelper(id, title)
    dispatcher._setObject(sp.getId(), sp)

    if REQUEST is not None:
        REQUEST['RESPONSE'].redirect( '%s/manage_workspace'
                                      '?manage_tabs_message='
                                      'wsseHelper+added.'
                                      % dispatcher.absolute_url() )

def register_wsse_plugin():
    try:
        registerMultiPlugin(plugin.WsseHelper.meta_type)
    except RuntimeError:
        # make refresh users happy
        pass    


def register_wsse_plugin_class(context):
    context.registerClass(plugin.WsseHelper,
                          permission = manage_users,
                          constructors = (manage_add_wsse_form,
                                        manage_add_wsse_helper),
                          visibility = None,
                          icon='browser/icon.gif'
                         )
