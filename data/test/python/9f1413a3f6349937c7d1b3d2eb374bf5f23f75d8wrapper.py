# -*- coding:utf-8 -*-
from zope.interface import implementer
from .interfaces import IRepository


@implementer(IRepository)
class RepositoryWrapper(object):
    def __init__(self, repository, adapter):
        self.repository = repository
        self.adapter = adapter

    def __getitem__(self, key):
        return self.adapter(self.repository[key])

    def get(self, key):
        item = self.repository.get(key)
        if item is None:
            return None
        return self.adapter(item)

    def get_many(self, keys):
        return (self.adapter(item)
                for item in self.repository.get_many(keys))

    def new_item(self):
        return self.adapter(self.repository.new_item())
