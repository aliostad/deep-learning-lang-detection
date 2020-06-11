# coding: utf-8
try:
    import unittest2 as unittest
except ImportError:
    import unittest
import mock

from pyodnoklassniki import OdnoklassnikiAPI


class OdnoklassnikiAPIChainingTest(unittest.TestCase):

    def test_method_group_and_name_are_empty_when_no_chain_is_provided(self):
        ok_api = OdnoklassnikiAPI()

        self.assertIsNone(ok_api._api_method_group)
        self.assertIsNone(ok_api._api_method_name)

    def test_magic_method_does_not_affect_group_or_name_assigning(self):
        ok_api = OdnoklassnikiAPI()
        # It invokes ``ok_api.__members__``, ``ok_api.__methods__``.
        dir(ok_api)

        self.assertIsNone(ok_api._api_method_group)
        self.assertIsNone(ok_api._api_method_name)

    def test_first_chain_produces_method_group(self):
        ok_api = OdnoklassnikiAPI()

        self.assertEqual(ok_api.group._api_method_group, 'group')
        self.assertIsNone(ok_api.group._api_method_name)

    def test_second_chain_produces_method_name(self):
        ok_api = OdnoklassnikiAPI()

        self.assertEqual(ok_api.group.getCurrentUser._api_method_group, 'group')
        self.assertEqual(ok_api.group.getCurrentUser._api_method_name,
                         'getCurrentUser')

    def test_third_chain_produces_attribute_error(self):
        ok_api = OdnoklassnikiAPI()

        expected_exc_message = (
            "'OdnoklassnikiAPI' method's group, name have already been set"
        )
        with self.assertRaisesRegexp(AttributeError, expected_exc_message):
            ok_api.group.name.blah


class OdnoklassnikiAPICallableTest(unittest.TestCase):

    def test_api_instance_is_not_callable(self):
        ok_api = OdnoklassnikiAPI()

        expected_exc_message = "'OdnoklassnikiAPI' object is not callable"
        with self.assertRaisesRegexp(TypeError, expected_exc_message):
            ok_api()

    def test_first_chain_of_api_instance_is_not_callable(self):
        ok_api = OdnoklassnikiAPI()

        expected_exc_message = "'OdnoklassnikiAPI' object is not callable"
        with self.assertRaisesRegexp(TypeError, expected_exc_message):
            ok_api.users()

    @mock.patch('pyodnoklassniki.requestor.session', autospec=True)
    def test_second_chain_of_api_instance_is_callable(self, r_session):
        ok_api = OdnoklassnikiAPI()

        ok_api.users.getCurrentUser()
