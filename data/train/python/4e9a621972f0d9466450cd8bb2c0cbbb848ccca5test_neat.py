from tests import AppTest, BaseTest, log
from webob import Request

from neat.neat import Resource, Dispatch

# Test resources.
class Foo(Resource):
    prefix = "/foo"

class Test(Resource):
    prefix = "/test"

class Tests(Resource):
    prefix = "/test/"

class Testing(Resource):
    prefix = "/testing"

class TestDispatch(BaseTest):

    def setUp(self):
        self.dispatch = Dispatch(Foo, Test, Tests, Testing)
        self.req = Request.blank("/test")

    def test_match(self):
        resource = self.dispatch.match(self.req, self.dispatch.resources)
        self.assertEqual(resource, Test)

    def test_match_reverse_order(self):
        resources = sorted(self.dispatch.resources, reverse=True)
        resource = self.dispatch.match(self.req, resources)
        self.assertEqual(resource, Test)

    def test_match_prefix(self):
        req = Request.blank("/testing")
        resource = self.dispatch.match(req, self.dispatch.resources)
        self.assertEqual(resource, Testing)

    def test_match_collection(self):
        req = Request.blank("/test/1")
        resource = self.dispatch.match(req, self.dispatch.resources)
        self.assertEqual(resource, Tests)
