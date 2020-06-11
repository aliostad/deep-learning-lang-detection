from AccessControl.Permissions import manage_users
from Products.PageTemplates.PageTemplateFile import PageTemplateFile
from Products.PluggableAuthService import registerMultiPlugin

import plugin

manage_add_shibboleth_headers_form = PageTemplateFile('browser/add_plugin',
                            globals(), __name__='manage_add_shibboleth_headers_form' )


def manage_add_shibboleth_headers_helper( dispatcher, id, title=None, REQUEST=None ):
    """Add an shibboleth_headers Helper to the PluggableAuthentication Service."""

    sp = plugin.Shibboleth_HeadersHelper( id, title )
    dispatcher._setObject( sp.getId(), sp )

    if REQUEST is not None:
        REQUEST['RESPONSE'].redirect( '%s/manage_workspace'
                                      '?manage_tabs_message='
                                      'shibboleth_headersHelper+added.'
                                      % dispatcher.absolute_url() )


def register_shibboleth_headers_plugin():
    try:
        registerMultiPlugin(plugin.Shibboleth_HeadersHelper.meta_type)
    except RuntimeError:
        # make refresh users happy
        pass


def register_shibboleth_headers_plugin_class(context):
    context.registerClass(plugin.Shibboleth_HeadersHelper,
                          permission = manage_users,
                          constructors = (manage_add_shibboleth_headers_form,
                                          manage_add_shibboleth_headers_helper),
                          visibility = None,
                          icon='browser/icon.gif'
                         )
