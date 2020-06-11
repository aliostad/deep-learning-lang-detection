from implugin.formskit.testing import FormskitControllerFixture

from implugin.auth.testing import AuthControllerFixture
from ..controllers import ForbiddenController
from .test_login_controller import MockedBaseAuthController


class ExampleForbiddenController(ForbiddenController, MockedBaseAuthController):
    pass


class TestForbiddenController(AuthControllerFixture, FormskitControllerFixture):
    _testable_cls = ExampleForbiddenController

    def test_create_context(self, testable):
        testable._create_context()

        assert testable.context == {
            'auth': {
                'header': ForbiddenController.header_text,
            }
        }

    def test_make_on_authenticated_user(self, testable, mgoto_login, fuser):
        fuser.is_authenticated.return_value = True

        testable.make()

        assert mgoto_login.called is False

    def test_make_on_unauthenticated_user(
        self,
        testable,
        mgoto_login,
        fuser,
    ):
        fuser.is_authenticated.return_value = False

        testable.make()

        mgoto_login.assert_called_once_with()
