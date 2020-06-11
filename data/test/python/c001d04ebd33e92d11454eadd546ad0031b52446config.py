""" pyramid config directives
"""

import functools
from .interfaces import IRepository, IRepositoryFactory

def includeme(config):
    config.add_directive('add_repository', add_repository)
    config.add_directive('add_repository_factory', add_repository_factory)


def add_repository(config, repository, name):
    reg = config.registry
    repository = config.maybe_dotted(repository)

    def register():
        reg.registerUtility(repository, IRepository, name=name)

    desc = "rebecca.repository:IRepository-{name}".format(name=name)
    intr = config.introspectable(category_name="rebecca.repository",
                                 discriminator=name,
                                 title=desc,
                                 type_name=repository.__class__.__name__)
    intr['value'] = repository
    config.action(desc,
                  register, introspectables=(intr,))


def add_repository_factory(config, factory, name, args=()):
    reg = config.registry
    factory = config.maybe_dotted(factory)
    factory = functools.partial(factory, *args)

    def register():
        reg.registerUtility(factory, IRepositoryFactory, name=name)

    desc = "rebecca.repository:IRepositoryFactory-{name}".format(name=name)
    intr = config.introspectable(category_name="rebecca.repositoryfactory",
                                 discriminator=name,
                                 title=desc,
                                 type_name=factory.__class__.__name__)
    intr['value'] = factory
    config.action(desc,
                  register, introspectables=(intr,))
