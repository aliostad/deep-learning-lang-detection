from AccessControl.Permissions import manage_users
from Products.PageTemplates.PageTemplateFile import PageTemplateFile
from Products.PluggableAuthService import registerMultiPlugin

import plugin

manage_add_rpx_form = PageTemplateFile('browser/add_plugin',
                            globals(), __name__='manage_add_rpx_form' )


def manage_add_rpx_helper( dispatcher, id, title=None, REQUEST=None ):
    """Add an rpx Helper to the PluggableAuthentication Service."""

    sp = plugin.RpxHelper( id, title )
    dispatcher._setObject( sp.getId(), sp )

    if REQUEST is not None:
        REQUEST['RESPONSE'].redirect( '%s/manage_workspace'
                                      '?manage_tabs_message='
                                      'rpxHelper+added.'
                                      % dispatcher.absolute_url() )


def register_rpx_plugin():
    try:
        registerMultiPlugin(plugin.RpxHelper.meta_type)
    except RuntimeError:
        # make refresh users happy
        pass


def register_rpx_plugin_class(context):
    context.registerClass(plugin.RpxHelper,
                          permission = manage_users,
                          constructors = (manage_add_rpx_form,
                                          manage_add_rpx_helper),
                          visibility = None,
                          icon='browser/icon.gif'
                         )
