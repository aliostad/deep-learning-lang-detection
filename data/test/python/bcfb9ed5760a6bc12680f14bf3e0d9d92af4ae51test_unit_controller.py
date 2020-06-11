import unittest2 as unittest
from collective.linguadomains.tests import base, utils
from collective.linguadomains import controller


class UnitTestController(base.UnitTestCase):
    """We tests the setup (install) of the addons. You should check all
    stuff in profile are well activated (browserlayer, js, content types, ...)
    """

    def setUp(self):
        context = utils.FakeContext()
        request = utils.FakeRequest()
        request._data['ACTUAL_URL'] = 'http://nohost-fr/plone/news'
        self.controller = controller.LinguaDomainsManager(context, request)
        self.controller._settings = utils.FakeSettings()
        self.controller._portal_url = 'http://nohost-fr/plone'

    def test_url_not_in_mapping(self):
        controller = self.controller
        controller._portal_url = 'http://notinmapping/plone'
        url = 'http://notinmapping/plone/news'
        controller.request._data['ACTUAL_URL'] = url
        self.assertEqual(controller.get_translated_url(),
                         'http://notinmapping/plone/news')

    def test_good_url(self):
        controller = self.controller
        controller.context.lang = 'fr'
        translated_url = controller.get_translated_url()
        self.assertEqual(translated_url,
                         'http://nohost-fr/plone/news')

    def test_should_redirect(self):
        controller = self.controller
        controller.context.lang = 'nl'
        translated_url = controller.get_translated_url()
        self.assertEqual(translated_url,
                        'http://nohost-nl/plone/news')

    def test_not_activated(self):
        controller = self.controller
        controller._settings.activated = False
        controller.context.lang = 'nl'
        translated_url = controller.get_translated_url()
        self.assertEqual(translated_url,
                         'http://nohost-fr/plone/news')

    def test_language_not_in_mapping(self):
        controller = self.controller
        controller.context.lang = 'xx'
        translated_url = controller.get_translated_url()
        self.assertEqual(translated_url,
                         'http://nohost-fr/plone/news')


def test_suite():
    return unittest.defaultTestLoader.loadTestsFromName(__name__)
