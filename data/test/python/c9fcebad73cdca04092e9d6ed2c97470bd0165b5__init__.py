from .config import includeme
from .interfaces import IRepository, IRepositoryFactory
from .decorators import repository_config, repository_factory_config

includeme = includeme  # for flakes
repository_config = repository_config  # for flakes
repository_factory_config = repository_factory_config  # for flakes


def get_repository(request, name):
    reg = request.registry
    return reg.queryUtility(IRepository, name=name)


def create_repository(request, name, args=(), kwargs={}):
    reg = request.registry
    factory = reg.queryUtility(IRepositoryFactory, name=name)
    return factory(*args, **kwargs)
