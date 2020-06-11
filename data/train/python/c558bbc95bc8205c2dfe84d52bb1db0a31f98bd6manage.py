from plone.app.portlets.browser import manage
from plone.app.viewletmanager import manager


class ManageContextualPortlets(manage.ManageContextualPortlets):
    __doc__ = manage.ManageContextualPortlets.__doc__

    def __call__(self, *args, **kwargs):
        self.request.response.setHeader('X-Theme-Disabled', 'True')
        self.request.environ['HTTP_X_THEME_ENABLED'] = False
        return super(ManageContextualPortlets, self).__call__(*args, **kwargs)


class ManageViewlets(manager.ManageViewlets):
    __doc__ = manager.ManageViewlets.__doc__

    def __call__(self, *args, **kwargs):
        self.request.response.setHeader('X-Theme-Disabled', 'True')
        self.request.environ['HTTP_X_THEME_ENABLED'] = False
        return super(ManageViewlets, self).__call__(*args, **kwargs)
