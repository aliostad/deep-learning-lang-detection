import unittest2 as unittest
from plone.app.mediarepository.testing import \
    MEDIAREPOSITORY_INTEGRATION_TESTING
from plone.app.cmsui.interfaces import IQuickUploadCapable


class MediaRepositoryTest(unittest.TestCase):

    layer = MEDIAREPOSITORY_INTEGRATION_TESTING

    def getLogger(self, value):
        return 'plone.app.mediarepository'

    def test_default_repository(self):
        site = self.layer['portal']
        self.assertTrue(hasattr(site, 'media-repository'))
        self.assertEquals(site['media-repository'].portal_type,
                          'media_repository')
        self.assertTrue(
            IQuickUploadCapable.providedBy(site['media-repository'])
        )
