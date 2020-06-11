# -*- coding: utf-8 -*-
"""API integration tests"""

from nass.api import NassApi
from util import api


def test_key():
    api = NassApi('api key')
    assert api.key == 'api key'


def test_sources(api):
    data = api.param_values('source_desc')
    assert data


def test_api_count(api):
    query = api.query()
    query.filter('commodity_desc', 'CORN')
    query.filter('year', 2012, 'ge')
    query.filter('county_code', 187)
    count = query.count()
    assert count
    assert isinstance(count, int)


def test_api_query(api):
    query = api.query()
    query.filter('commodity_desc', 'CORN')
    query.filter('year', 2012, 'ge')
    query.filter('county_code', 187)
    data = query.execute()
    assert data
