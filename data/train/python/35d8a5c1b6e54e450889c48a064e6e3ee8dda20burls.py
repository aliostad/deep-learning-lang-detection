#!/usr/bin/env python
# encoding: utf-8

"""
@author: liuweiqing
@software: PyCharm Community Edition
@file: urls.py
@date: 16/3/17 下午4:06
"""

from handlers import api

urls = [
    (r"/api.login", api.Login),
    (r'/api.signup', api.SignUp),
    (r'/api.jsfile', api.JsFile),
    (r'/api.search_user', api.SearchUserByMobile),
    (r'/api.apply.friend', api.AppleFriend),
    (r'/api.userinfo', api.UserInfo),
    (r'/api.accept', api.AcceptFriend),
    (r'/api.friends', api.Friends),
    (r'/api.upload_token', api.UploadToken),
    (r'/api.update_userinfo', api.UpdateUserInfo),
    (r'/', api.Nginx)
]
