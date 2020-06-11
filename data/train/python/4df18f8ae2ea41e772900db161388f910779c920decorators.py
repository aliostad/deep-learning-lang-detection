import venusian
from .config import add_repository, add_repository_factory


def repository_config(name, args=()):
    def dec(repository_factory):
        def callback(scanner, _, ob):
            ob = repository_factory(*args)
            add_repository(scanner.config, ob, name)
        venusian.attach(repository_factory, callback=callback)
        return repository_factory
    return dec


def repository_factory_config(name, args=()):
    def dec(repository_factory):
        def callback(scanner, _, ob):
            add_repository_factory(scanner.config, ob, name, args)
        venusian.attach(repository_factory, callback=callback)
        return repository_factory
    return dec