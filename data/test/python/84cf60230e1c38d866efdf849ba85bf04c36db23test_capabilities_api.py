import unittest
import httpretty
from sure import expect

from wikimapia_api.api import API
import wikimapia_api.capabilities_api
from .helpers import mock_request, without_resource_warnings

class TestCapabilitiesAPI(unittest.TestCase):
    def setUp(self):
        API.config = {'compression': False, 'delay': 1}
        API.clear_entire_cache()

    def tearDown(self):
        API.config.reset()

    @httpretty.activate
    @without_resource_warnings
    def test_language(self):
        mock_request('api.getlanguages.json')
        expect(API.languages['en']).to.equal('English')
        expect(API.languages['ru']).to.equal('Russian')
