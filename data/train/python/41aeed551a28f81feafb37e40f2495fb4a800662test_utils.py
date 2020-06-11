"""Tests for go.api.go_api.utils."""

from mock import Mock

from vumi.tests.helpers import VumiTestCase

from go.api.go_api.utils import GoApiError, GoApiSubHandler


class TestGoApiError(VumiTestCase):
    def test_go_api_error(self):
        err = GoApiError("Testing")
        self.assertEqual(err.faultString, "Testing")
        self.assertEqual(err.faultCode, 400)

    def test_go_api_error_with_fault_code(self):
        err = GoApiError("Other", fault_code=314)
        self.assertEqual(err.faultString, "Other")
        self.assertEqual(err.faultCode, 314)


class TestGoApiSubHandler(VumiTestCase):
    def setUp(self):
        self.account = Mock(key=u"account-1")
        self.user_api = Mock()
        self.vumi_api = Mock(
            get_user_api=Mock(return_value=self.user_api),
        )

    def test_create(self):
        sub = GoApiSubHandler(self.account.key, self.vumi_api)
        self.assertEqual(sub.user_account_key, self.account.key)
        self.assertEqual(sub.vumi_api, self.vumi_api)

    def test_get_user_api(self):
        sub = GoApiSubHandler(self.account.key, self.vumi_api)
        user_api = sub.get_user_api(self.account.key)
        self.assertTrue(
            self.vumi_api.get_user_api.called_once_with(self.account.key))
        self.assertEqual(user_api, self.user_api)

    def test_get_user_api_with_invalid_campaign_key(self):
        sub = GoApiSubHandler(self.account.key, self.vumi_api)
        self.assertRaises(GoApiError, sub.get_user_api, u"foo")
