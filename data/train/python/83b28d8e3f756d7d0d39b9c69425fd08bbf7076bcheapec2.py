#! /usr/bin/env python

import tornado.ioloop
import tornado.options
import tornado.web

from api.controller.BaseStaticFileHandler import BaseStaticFileHandler

from api.controller.RegionListController import RegionListController
from api.controller.CategoryListController import CategoryListController
from api.controller.SizeListController import SizeListController
from api.controller.PriceController import PriceController
from api.controller.InfoController import InfoController

# Bootup
application = tornado.web.Application([
    (r"/api/price", PriceController),
    (r"/api/categories", CategoryListController),
    (r"/api/sizes", SizeListController),
    (r"/api/info", InfoController),
    (r"/api/regions", RegionListController),
    (r"/(.*)", BaseStaticFileHandler, {"path": "www"})
], debug="True")


if __name__ == "__main__":
    tornado.options.parse_command_line()
    application.listen(8080)
    tornado.ioloop.IOLoop.instance().start()
