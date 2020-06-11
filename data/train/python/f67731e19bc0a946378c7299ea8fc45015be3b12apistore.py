# -*- coding: utf-8 -*-
#
# Author: Orcun Avsar <orc.avs@gmail.com>

"""Stores Tastypie APIs.
"""

from tastypie.api import Api


APIs = {}


class APINotDiscoveredError(Exception):
    pass


def get_or_create(api_name):
    api = APIs.get(api_name)
    if not api:
        api = Api(api_name)
        APIs[api_name] = api
    return api


def get_all():
    return APIs.values()


def get(api_name):
    """Returns Tastpie API for given API name.
    """
    api = APIs.get(api_name)
    if not api:
        raise APINotDiscoveredError('API with name "%s" was not discovered.')
    return api
