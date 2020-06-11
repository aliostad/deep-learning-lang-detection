from ftw.builder import Builder
from ftw.builder import builder_registry
from ftw.builder import create


class RepositoryTreeBuilder(object):
    """Meta builder to create a simple repository-tree."""

    def __init__(self, session):
        self.session = session

    def create(self):
        repository_root = create(Builder('repository_root'))
        repository_folder = create(Builder('repository')
                                   .within(repository_root))

        return repository_root, repository_folder

builder_registry.register('repository_tree', RepositoryTreeBuilder)
