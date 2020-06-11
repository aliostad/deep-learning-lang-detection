from AccessControl.Permissions import manage_users
from Products.PageTemplates.PageTemplateFile import PageTemplateFile
from Products.PluggableAuthService import registerMultiPlugin

import plugin

manage_add_package_form = PageTemplateFile('browser/add_plugin',
                            globals(), __name__='manage_add_package_form')


def manage_add_package_helper(dispatcher, id, title=None, REQUEST=None):
    """Add a sample plugin to the PluggableAuthentication Service."""

    sp = plugin.PackagePlugin(id, title)
    dispatcher._setObject(sp.getId(), sp)

    if REQUEST is not None:
        REQUEST['RESPONSE'].redirect('%s/manage_workspace'
                                     '?manage_tabs_message='
                                     'packageHelper+added.'
                                      % dispatcher.absolute_url())


def register_package_plugin():
    try:
        registerMultiPlugin(plugin.PackagePlugin.meta_type)
    except RuntimeError:
        # make refresh users happy
        pass


def register_package_plugin_class(context):
    context.registerClass(plugin.PackagePlugin,
                          permission=manage_users,
                          constructors=(manage_add_package_form,
                                          manage_add_package_helper),
                          visibility=None,
                          icon='browser/battery.png'
                         )
