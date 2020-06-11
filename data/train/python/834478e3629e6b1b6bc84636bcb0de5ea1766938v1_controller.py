import pecan
from pecan import rest

from radar.api.v1.auth import AuthController
from radar.api.v1.subscription import SubscriptionsController
from radar.api.v1.system import SystemsController
from radar.api.v1.operator import OperatorsController
from radar.api.v1.user import UsersController

class V1Controller(rest.RestController):

    systems = SystemsController()
    operators = OperatorsController()
    users = UsersController()
    subscriptions = SubscriptionsController()
    
    openid = AuthController()

