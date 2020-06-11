from ftw.bridge.proxy.testing import PYRAMID_LAYER
from ftw.bridge.proxy.views import ManageView
from pyramid.httpexceptions import HTTPFound
from pyramid.httpexceptions import HTTPUnauthorized
from pyramid.testing import DummyRequest
from unittest2 import TestCase


AUTH_HEADERS = {
    'Authorization': 'Basic %s' % 'chef:1234'.encode('base64'),
    'Referer': 'http://bridge/manage'}


class TestManageView(TestCase):

    layer = PYRAMID_LAYER

    def test_view_is_protected(self):
        request = DummyRequest()

        view = ManageView(request)
        with self.assertRaises(HTTPUnauthorized):
            view()

    def test_view_lists_clients(self):
        request = DummyRequest(headers=AUTH_HEADERS)

        view = ManageView(request)
        html = view().body
        self.assertIn('foo', html)
        self.assertIn('bar', html)
        self.assertIn('127.0.0.1', html)

    def test_activate_maintenance(self):
        request = DummyRequest(headers=AUTH_HEADERS)
        self.assertNotIn('Maintenance', ManageView(request)().body)

        # enable maintenance for client "foo"
        request = DummyRequest(headers=AUTH_HEADERS,
                               params={'clientid': 'foo',
                                       'status': 'maintenance'})
        response = ManageView(request)()
        self.assertTrue(isinstance(response, HTTPFound))
        self.assertEqual(response.location, 'http://bridge/manage')

        # maintenance is active now
        request = DummyRequest(headers=AUTH_HEADERS)
        self.assertIn('Maintenance', ManageView(request)().body)

        # disable maintenance for client "foo"
        request = DummyRequest(headers=AUTH_HEADERS,
                               params={'clientid': 'foo',
                                       'status': 'online'})
        response = ManageView(request)()
        self.assertTrue(isinstance(response, HTTPFound))
        self.assertEqual(response.location, 'http://bridge/manage')

        # maintenance is not active anymore
        request = DummyRequest(headers=AUTH_HEADERS)
        self.assertNotIn('Maintenance', ManageView(request)().body)
