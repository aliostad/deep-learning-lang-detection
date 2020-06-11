# -*- coding: utf-8 -*-
from flod_tilskudd_portal.api.filters_soknader_resource import FiltersSoknaderResource

from flod_tilskudd_portal.api.soknad_resource import SoknaderResource
from flod_tilskudd_portal.api.tilskudd_api import TilskuddApi


def create_api(app, api_version,
               soknad_resource=SoknaderResource,
               filters_soknader_resource=FiltersSoknaderResource):
    api = TilskuddApi(app)

    api.add_resource(soknad_resource,
                     '/tilskudd/api/%s/soknader/' % api_version)

    api.add_resource(filters_soknader_resource,
                     '/tilskudd/api/%s/filters/soknader' % api_version)

    return api


