# -*- coding:utf-8 -*-
# !/usr/bin/env python
#
# Author: Shawn.T
# Email: shawntai.ds@gmail.com
#
# This is the init file for the user package
# holding api & urls of the user module
#
from .auth import TokenAPI
from .mgmt import UserAPI, RoleAPI, PrivilegeAPI
from .. import api

api.add_resource(
    TokenAPI, '/api/v0.0/user/token', endpoint='token_ep')
api.add_resource(
    UserAPI, '/api/v0.0/user/user', endpoint='user_ep')
api.add_resource(
    RoleAPI, '/api/v0.0/user/role', endpoint='role_ep')
api.add_resource(
    PrivilegeAPI, '/api/v0.0/user/privilege', endpoint='priv_ep')
