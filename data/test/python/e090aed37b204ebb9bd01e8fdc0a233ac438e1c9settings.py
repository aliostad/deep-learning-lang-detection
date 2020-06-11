from bundles.userbundle.controllers.profilesresourceslinkcontroller import ProfilesResourcesLinkController
from bundles.userbundle.controllers.logincontroller import LoginController
from bundles.userbundle.controllers.usercontroller import UserController
from bundles.userbundle.controllers.resourcecontroller import ResourceController
from bundles.userbundle.controllers.profilecontroller import ProfileController
from bundles.userbundle.helpers.loaderhelper import LoaderHelper


CONTROLLERS_DIRECTORY = "/controllers/"

#Put your controllers here in a tuple like next format:
#(CONTROLLER_CLASS, REGEX_PATH)
CONTROLLERS=[
    (ProfilesResourcesLinkController, "/profiles/<profile_id>/resources",  "/profiles/<profile_id>/resources/<resource_id>"),
    (LoginController, "/login"),
    (UserController, "/users", "/users/<user_id>"),
    (ResourceController, "/resources", "/resources/<resource_id>"),
    (ProfileController, "/profiles", "/profiles/<profile_id>")
]

LoaderHelper.init()