#!/usr/bin/env python
# coding: utf-8
from handler import todo
pre_fix = todo

handlers = [
    # ('/',                    pre_fix.IndexHandler),
    (r'^/',                    pre_fix.Login),
    (r'^/main',                    pre_fix.Main),
    (r'^/login',            pre_fix.Login),
    (r'^/jqgrid',            pre_fix.Jqgrid),
    (r'^/logout',            pre_fix.Logout),
    (r'^/userManage',            pre_fix.UeserManage),
    (r'^/userManageList',            pre_fix.UeserManageList),
    (r'^/test',            pre_fix.Test),
    # (r'^/todo/(\d+)/edit',     pre_fix.EditHandler),
    # (r'^/todo/(\d+)/delete',   pre_fix.DeleteHandler),
    # (r'^/todo/(\d+)/finish',   pre_fix.FinishHandler)


]
