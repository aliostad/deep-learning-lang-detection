# -*- coding: utf-8 -*-

# Copyright (c) 2013 - 2015 CoNWeT Lab., Universidad Politécnica de Madrid

# This file is part of WStore.

# WStore is free software: you can redistribute it and/or modify
# it under the terms of the European Union Public Licence (EUPL)
# as published by the European Commission, either version 1.1
# of the License, or (at your option) any later version.

# WStore is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# European Union Public Licence for more details.

# You should have received a copy of the European Union Public Licence
# along with WStore.
# If not, see <https://joinup.ec.europa.eu/software/page/eupl/licence-eupl>.


from __future__ import unicode_literals

from django.core.exceptions import ObjectDoesNotExist

from wstore.store_commons.errors import ConflictError
from wstore.models import Repository


def register_repository(name, host, offering_collection, resource_collection, api_version, default=False):
    """
    Register a new repository in WStore, these repositories will be used for the storage
    of the USDL descriptions of offerings and resources
    """

    if host[-1] != '/':
        host += '/'

    # Check if the repository name is in use
    if len(Repository.objects.filter(name=name) | Repository.objects.filter(host=host)) > 0:
        raise ConflictError('The given repository is already registered')

    # If the repository will be the default one modify the existing repos
    if default:
        _unset_default()

    # If this is the first repository registered default must be true
    elif len(Repository.objects.all()) == 0:
        default = True

    Repository.objects.create(
        name=name,
        host=host,
        offering_collection=offering_collection,
        resource_collection=resource_collection,
        api_version=api_version,
        is_default=default
    )


def _get_repository(repository):
    rep = None
    try:
        rep = Repository.objects.get(name=repository)
    except:
        raise ObjectDoesNotExist('The specified repository does not exist')

    return rep


def _unset_default():
    # Change the default repository
    def_rep = Repository.objects.filter(is_default=True)
    for rep in def_rep:
        rep.is_default = False
        rep.save()


def unregister_repository(repository):
    """
    Unregisters a repository from WStore
    """

    rep = _get_repository(repository)
    # Remove the repository object
    rep.delete()

    # Check if the deleted repository is the default one
    if rep.is_default:
        repos = Repository.objects.all()
        if len(repos) > 0:
            repos[0].is_default = True
            repos[0].save()


def get_repositories():

    repositories = Repository.objects.all()
    response = []

    for rep in repositories:
        response.append({
            'name': rep.name,
            'host': rep.host,
            'is_default': rep.is_default,
            'offering_collection': rep.offering_collection,
            'resource_collection': rep.resource_collection,
            'api_version': rep.api_version
        })

    return response


def set_default_repository(repository):

    rep = _get_repository(repository)
    _unset_default()
    rep.is_default = True
    rep.save()
