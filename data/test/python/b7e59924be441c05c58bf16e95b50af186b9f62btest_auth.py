"""
Testing of website authentication and security 
"""

from gyro import auth, controller
from twisted.trial import unittest

class TestProvider(auth.AuthProvider):
    pass

class AuthTest(unittest.TestCase):
    def test_decorator(self):
        """
        Test that the decorator sets auth_provider correctly
        """
        @auth.secure()
        class TestController(controller.Controller):
            pass
            
        self.assertEquals(TestController.auth_provider, auth.AuthProvider)
        
        @auth.secure(TestProvider)
        class AnotherController(controller.Controller):
            pass
        
        self.assertEquals(AnotherController.auth_provider, TestProvider)
        
        class PageController(controller.Controller):
            @auth.secure(TestProvider)
            def foo(self):
                pass
            
        self.assertEquals(PageController.foo.auth_provider, TestProvider)
    