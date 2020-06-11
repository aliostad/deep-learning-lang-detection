#!/usr/bin/env python
# -*- coding: utf-8 -*-

import tornado.web
from base import *
from controller import UserController
from controller import DeviceController
from controller import BaseController
from controller import LocController
from controller import AppController
from controller import BlackListController
from controller import AndroidController
from controller import MsgController
from controller import TemplateController
from controller import DocController
from controller import PolicyController
from controller import PushController
handlers = []

'''
首页载入时的一些基础信息配置
	/base/config		#包括用户信息、menu信息在内的基础信息
	/base/status_check	#首页右上角的状态信息
'''
handlers += BaseController.handlers

'''
DeviceController:	处理设备请求
	/device/register_history	#注册设备历史信息
	/device/statistics			#设备统计信息
	/device/register/list		#注册设备列表信息
	/device/active/list			#激活设备列表信息
'''
handlers += DeviceController.handlers

'''
UserController:			处理用户请求
	/user/register		#注册账户
	/user/login 		#登陆
	/user/logout 		#登出
'''
handlers += UserController.handlers

handlers += LocController.handlers

handlers += AppController.handlers

handlers += BlackListController.handlers

handlers += MsgController.handlers

handlers += AndroidController.handlers

handlers += TemplateController.handlers

handlers += DocController.handlers

handlers += PolicyController.handlers

handlers += PushController.handlers

handlers += [(r"^/(.*)$", AuthenHandler)]

