from giza.models import Application, Context
from giza.resources import giza_resources
import giza.framework as api

@api.view
class Index(api.View):
    api.context(Context)
    api.template('templates/index.pt')

    def update(self):
        giza_resources.need()


@api.view
class MainTemplate(api.View):
    api.context(Context)
    api.name('main_template')
    api.template('templates/main_template.pt')

@api.view
class NavigationBar(api.View):
    api.context(Context)
    api.name('navigation_bar')
    api.template('templates/navigation_bar.pt')


@api.view
class AddPlugin(api.View):
    api.context(Application)
    api.name('add_plugin')
    api.template('templates/add_plugin.pt')


