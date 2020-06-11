import unittest
from signals.parser.api import API, GetAPI, RequestResponseAPI
from signals.logging import SignalsError


class APITestCase(unittest.TestCase):
    def test_create_api(self):
        api = API("user/", {
            "doc": "Get user information",
            "#meta": "oauth2"
        })
        self.assertEqual(api.url_path, "user/")
        self.assertEqual(api.documentation, "Get user information")
        self.assertEqual(api.content_type, API.CONTENT_TYPE_JSON)
        self.assertEqual(api.authorization, API.OAUTH2)
        self.assertFalse(api.authorization_optional)

    def test_set_authorization(self):
        api = API("user/", {})
        self.assertIsNone(api.authorization)

        api.set_authorization({"#meta": "basicauth, optional"})

        self.assertTrue(api.authorization_optional)
        self.assertEqual(api.authorization, API.BASIC_AUTH)

    def test_process_authorization_attribute_error(self):
        with self.assertRaises(SignalsError) as e:
            API("post/", {
                "#meta": "oauth"
            })
        self.assertEqual(e.exception.msg, "Found invalid authorization attribute: oauth for post/, exiting.")

    def test_create_get_api(self):
        api = GetAPI("post/", {
            "response": {
                "200+": "$postResponse"
            }
        })
        self.assertEqual(api.response_object, "$postResponse")
        self.assertEqual(api.resource_type, GetAPI.RESOURCE_LIST)

    def test_create_get_api_detail(self):
        api = GetAPI("post/:id/", {
            "response": {
                "200+": "$postResponse"
            }
        })
        self.assertEqual(api.response_object, "$postResponse")
        self.assertEqual(api.resource_type, GetAPI.RESOURCE_DETAIL)

    def test_create_get_api_detail_override(self):
        api = GetAPI("post/:id/favorites/", {
            "resource_type": "list",
            "response": {
                "200+": "$postResponse"
            }
        })
        self.assertEqual(api.response_object, "$postResponse")
        self.assertEqual(api.resource_type, GetAPI.RESOURCE_LIST)

    def test_create_request_response_api(self):
        api = RequestResponseAPI("post/:id/favorites/", {
            "request": "$postRequest",
            "response": {
                "200+": "$postResponse"
            }
        })
        self.assertEqual(api.response_object, "$postResponse")
        self.assertEqual(api.request_object, "$postRequest")
