#!/usr/bin/env python3

import sys, os

import tornado.ioloop
import tornado.web

import api.login
import api.user
import api.notifications
import api.chat

import config

if __name__ == "__main__":

    if sys.argv[1] and sys.argv[2] and sys.argv[3]:
        config.gh_id = sys.argv[1]
        config.gh_secret = sys.argv[2]
        config.app_secret = sys.argv[3]

        application = tornado.web.Application([
            (r"/api/login/?", api.login.Handler),
            (r"/api/user/?", api.user.UserHandler),
            (r"/api/profile/(?P<uid>[^\/]+)/?", api.user.ProfileHandler),
            (r"/api/like/(?P<target_id>[^\/]+)/?", api.user.LikeHandler),
            (r"/api/reject/(?P<target_id>[^\/]+)/?", api.user.RejectHandler),
            (r"/api/find/?", api.user.FindHandler),
            (r"/api/matches/?", api.user.MatchesHandler),
            (r"/api/token/?", api.user.TokenHandler),
            (r"/api/snippet/(?P<uid>[^\/]+)/?", api.user.SnippetHandler),

            (r"/api/notifications/?", api.notifications.NotificationsWebSocket),
            (r"/api/chat/?", api.chat.ChatWebSocket)

        ], cookie_secret=config.app_secret)

        application.listen(8888)
        tornado.ioloop.IOLoop.instance().start()
