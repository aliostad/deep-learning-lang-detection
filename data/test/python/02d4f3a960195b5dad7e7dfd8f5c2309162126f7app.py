# coding=utf-8
import os
import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web
from tornado.options import options, define

import handler
from db import BaseDB

define("port", default = 8001, help = "run on the given port", type = int)


class Application(tornado.web.Application):
    def __init__(self):
        settings = dict(
            template_path = os.path.join(os.path.dirname(__file__), "templates"),
            static_path = os.path.join(os.path.dirname(__file__), "static"),
            xsrf_cookies = True,
            cookie_secret = "8B12CB2EEF49B4431EE27D1654060710",
            login_url = "/login",
            debug=True,
            autoescape = None
        )

        handlers = [
            (r"/", handler.IndexHandler),
            (r"/news", handler.NewsHandler),
            (r"/login", handler.LoginHandler),
            (r"/manage", handler.ManageHandler),
            (r"/manage/image", handler.ManageImageHandler),
            (r"/manage/news", handler.ManageNewsHandler),
            (r"/manage/system", handler.ManageSystemHandler)
        ]

        tornado.web.Application.__init__(self, handlers, **settings)

        self.db = BaseDB()


def main():
    tornado.options.parse_command_line()
    http_server = tornado.httpserver.HTTPServer(Application())
    http_server.listen(options.port)
    print 'start server on', options.port
    tornado.ioloop.IOLoop.instance().start()


if __name__ == "__main__":
    main()
