from django.test import TestCase

from lib.square.api import SquareApi


class SquareApiTest(TestCase):
    def test_request(self):
        api = SquareApi()
        response = api.request('/items')
        self.assertEquals(response.status_code, 200)

    def test_get_items(self):
        api = SquareApi()
        response = api.get_items()
        self.assertEquals(response.status_code, 200)

    def test_get_orders(self):
        api = SquareApi()
        response = api.get_orders()
        self.assertEquals(response.status_code, 200)

        print response.content

    def test_get_payments(self):
        api = SquareApi()
        response = api.get_payments()
        self.assertEquals(response.status_code, 200)

        print response.content