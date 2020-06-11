from AccessControl.Permissions import manage_users
from Products.PageTemplates.PageTemplateFile import PageTemplateFile
from Products.PluggableAuthService import registerMultiPlugin

import plugin

manage_add_shibboleth_form = PageTemplateFile('browser/add_plugin',
                            globals(), __name__='manage_addShibbolethHelperForm' )


def manage_add_shibboleth_helper( dispatcher, id, title=None, REQUEST=None ):
    ''' Add an pas Shibboleth to the PluggableAuthentication Service.
    '''

    sp = plugin.ShibbolethHelper( id, title )
    dispatcher._setObject( sp.getId(), sp )

    if REQUEST is not None:
        REQUEST['RESPONSE'].redirect( '%s/manage_workspace'
                                      '?manage_tabs_message='
                                      'ShibbolethHelper+added.'
                                      % dispatcher.absolute_url() )


def register_pas_plugin():
    try:
        registerMultiPlugin(plugin.ShibbolethHelper.meta_type)
    except RuntimeError:
        # make refresh users happy
        pass


def register_pas_plugin_class(context):
    context.registerClass(plugin.ShibbolethHelper,
                          permission = manage_users,
                          constructors = (manage_add_shibboleth_form,
                                          manage_add_shibboleth_helper,),
                          visibility = None,
                          icon = 'www/shib.png'
                         )
    context.registerHelp(directory='help', clear=1)
