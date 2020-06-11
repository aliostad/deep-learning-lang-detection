# -*- coding:utf-8 -*-

from controller.base import MainHandler, HeartbeatHandler
from controller import AuthController, AgentController, PackageController

urls = [
    (r"/", MainHandler),
    (r"/heartbeat", HeartbeatHandler),
    (r"/auth/login", AuthController.LoginHandler),
    (r"/auth/logout", AuthController.LogoutHandler),
    (r"/auth/register", AuthController.RegisterHandler),
    (r"/agent/add", AgentController.AddHandler),
    (r"/agent/list", AgentController.ListHandler),
    (r"/agent/manage/(\d+)", AgentController.ManageHandler),
    (r"/package/upload", PackageController.UploadHandler),
    (r"/package/upload/notify", PackageController.UploadNotifyHandler),
    (r"/package/upload/multipart", PackageController.UploadMultipartHandler),
]