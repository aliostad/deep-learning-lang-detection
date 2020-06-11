#pylint: disable-msg=W0612,C0103,R0903
from pvscore.tests import TestController
from pvscore.lib.billing_api import BaseBillingApi

# bin/T pvscore.tests.functional.test_billing_api

class TestBillingApi(TestController):

    def test_null_api(self):
        """ KB: [2012-10-11]: Contrived to get coverage up. """
        api = BaseBillingApi.create_api(None)
        api.purchase(None, None, None)
        api.get_last_status()
        api.set_coupon(None)
        api.is_declined()
        api.create_token(None, None, None, None, None)
        api.cancel_order(None, None)
        api.is_declined()
        api.get_last_status()

