# ptah manage api

from ptahcms.manage.apps import MANAGE_APP_ROUTE
from ptahcms.manage.apps import MANAGE_APP_CATEGORY

# pyramid include
def includeme(config):
    config.add_route(
        MANAGE_APP_ROUTE, '# {0}'.format(MANAGE_APP_ROUTE),
        use_global_views=False)

    # manage templates
    config.add_layer('ptahcms-manage', path='ptahcms:templates/manage')

    # manage layouts
    from ptah.manage.manage import PtahManageRoute, LayoutManage
    from ptah.view import MasterLayout
    from ptahcms.interfaces import IApplicationRoot

    config.add_layout(
        'ptah-manage', PtahManageRoute, route_name=MANAGE_APP_ROUTE,
        renderer='ptah-manage:ptah-manage.lt', view=LayoutManage,
        use_global_views=False, parent='workspace'
    )

    config.add_layout(
        '', IApplicationRoot, parent='ptah-manage', route_name=MANAGE_APP_ROUTE,
        renderer='ptahcms-manage:apps-layout.lt',
        use_global_views=False, 
    )
