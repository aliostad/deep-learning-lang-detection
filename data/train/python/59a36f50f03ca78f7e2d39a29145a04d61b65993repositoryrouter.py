import os
from twisted.plugin import IPlugin
from zope.interface.declarations import implements
from gitexd import Factory
from gitexd.interfaces import IRepositoryRouter

class DrupalRepositoryRouter(object):
  implements(IPlugin, IRepositoryRouter)

  def route(self, app, repository):
    assert isinstance(app, Factory)
    assert isinstance(repository, list)

    if len(repository) <= 1:
      return None
    else:
      scheme = repository[0]
      project = repository[1:]

      if not app.getConfig().has_section(scheme):
        scheme = "DEFAULT"

      schemePath = app.getConfig().get(scheme, "repositoryPath")

      path = os.path.join(schemePath, *project)

      if not os.path.exists(path):
        return None
      else:
        return path

repositoryRouter = DrupalRepositoryRouter()