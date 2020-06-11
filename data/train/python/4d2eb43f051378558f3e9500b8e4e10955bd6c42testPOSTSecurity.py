import unittest
from zExceptions import Forbidden
from Products.CMFFormController.tests import CMFFormControllerTestCase

from Products.CMFFormController.ControllerPageTemplate import manage_addControllerPageTemplate
from Products.CMFFormController.ControllerState import ControllerState
from Products.CMFFormController.FormController import FormController

class TestPOSTSecurity(CMFFormControllerTestCase):
    """A simple test to show that the form can optionally require POST requests
    """

    def afterSetUp(self):
        manage_addControllerPageTemplate(self.portal, 'base_controller')
        self.base_controller = self.portal.base_controller
        self.base_state = ControllerState(id="my_id", context=self.portal,
                                          button="default")

    def test_POSTRequiredOffByDefault(self):
        self.failIf(self.base_controller.getPOSTRequired())

    def test_changePOSTRequired(self):
        self.base_controller.require_post = True
        self.failUnless(self.base_controller.getPOSTRequired)

    def test_GETSucceedsByDefault(self):
        self.assertEqual(self.app.REQUEST['REQUEST_METHOD'], 'GET')
        self.base_controller.getValidators(self.base_state, self.app.REQUEST)

    def test_GETFailsWhenDisallowed(self):
        self.base_controller.require_post = True
        self.assertRaises(Forbidden, self.base_controller.getValidators, self.base_state, self.app.REQUEST)

    def test_POSTSucceedsWhenGETDisallowed(self):
        self.app.REQUEST['REQUEST_METHOD'] = 'POST'
        self.assertEqual(self.app.REQUEST['REQUEST_METHOD'], 'POST')
        self.base_controller.require_post = True
        self.base_controller.getValidators(self.base_state, self.app.REQUEST)


def test_suite():
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(TestPOSTSecurity))
    return suite

if __name__ == '__main__':
    unittest.main(defaultTest="test_suite")
