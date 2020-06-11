#!/usr/bin/env python
#-*- coding:utf-8 -*-

import functools


class CacheManager(object):
    """The application level context of cache store."""

    def __init__(self, cache_store):
        self.store = cache_store

    def broker(self, key, ttl=None):
        """Same as "make_broker" but could be used as decorator."""
        return functools.partial(self.make_broker, key=key, ttl=ttl)

    def make_broker(self, key, factory, ttl=None):
        """Creates a cache broker bound to this cache store."""
        broker = CacheBroker(factory, self.store, key, ttl)
        return functools.update_wrapper(wrapper=broker, wrapped=factory)


class CacheBroker(object):
    """The broker of cache store.

    This broker would try to fetch value from cache store, and call the
    factory to generate a new value while failure.

    The new value will be save into cache store automatic.
    """

    def __init__(self, factory, cache_store, cache_key, cache_ttl=None):
        self.factory = factory
        self.cache_store = cache_store
        self.cache_key = cache_key
        self.cache_ttl = cache_ttl

    def __call__(self, **kwargs):
        return self.get_value(**kwargs)

    def get_value(self, **kwargs):
        value = self.cache_store.get(self.cache_key.format(**kwargs))
        if not value:
            value = self.factory(**kwargs)
            self.cache_store.set(self.cache_key, value, self.cache_ttl)
        return value

    def flush(self, **kwargs):
        """Removes old value in cache and generate with new input."""
        self.cache_store.remove(self.cache_key.format(**kwargs))
        return self.get_value(**kwargs)
