from master.httpcontroller.login_controller import LoginController
from master.httpcontroller.logout_controller import LogoutController
from master.httpcontroller.base_controller import BaseHttpController
from master.httpcontroller.redirect_controller import RedirectController
from master.httpcontroller.user_controller import UserController
from master.httpcontroller.pws_controller import PwsController
from master.httpcontroller.env_controller import EnvController
from master.httpcontroller.account_controller import AccountController

from master.logger.file_logger import logger
from urllib.parse import urlparse

import re


def get_action_match(action_type, pylet):
    """
    :param action_type: String (user or pws)
    :param pylet:  string
    :return: tuple of regex, string(action)
    """
    action_op_match = re.match(r'/' + action_type + '/(\w+)', pylet)
    action = None
    try:
        if action_op_match and action_op_match:
            action = action_op_match.group(1)
    except IndexError:
        logger().error('Unable to get user action from pylet:' + pylet)

    return action_op_match, action


def getHttpController(pylet_path, request_handler):
    """
    Gets Http Controller based on URL path
    :param pylet_path: String
    :param request_handler: CustomHTTPHandler
    :return: of BaseHttpController
    """
    url_object = urlparse(pylet_path)
    pylet = url_object.path

    # users operations controller
    user_op_match, user_action = get_action_match('user', pylet)
    # pws operations controller
    pws_op_match, pws_action = get_action_match('pws', pylet)
    # env operations controller
    env_op_match, env_action = get_action_match('env', pylet)
    # reset password controller
    reset_op_match, reset_action = get_action_match('account', pylet)

    logger().info('pylet=' + pylet + ';')

    if pylet is None:
        return None
    elif pylet == '/':
        return RedirectController(request_handler, '/index.html')
    elif pylet == '/login':
        return LoginController(request_handler)
    elif pylet == '/logout':
        return LogoutController(request_handler)
    elif user_op_match:
        return UserController(request_handler, user_action)
    elif pws_op_match:
        return PwsController(request_handler, pws_action)
    elif env_op_match:
        return EnvController(request_handler, env_action)
    elif reset_op_match:
        return AccountController(request_handler, reset_action)

    return BaseHttpController(request_handler)