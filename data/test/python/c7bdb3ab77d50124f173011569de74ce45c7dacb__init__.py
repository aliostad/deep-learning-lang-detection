from pecan import request, response, redirect
from draughtcraft.lib.notice import notify
from pecan.secure import SecureController
from password import PasswordController
from profile import ProfileController
from recipe import RecipeController


class SettingsController(SecureController):

    @classmethod
    def check_permissions(cls):
        if request.context['user'] is None:
            notify(
                'Sign up for a (free) account to take advantage of this '
                'feature.'
            )
            redirect('/signup', headers=response.headers)
        return True

    password = PasswordController()
    profile = ProfileController()
    recipe = RecipeController()
