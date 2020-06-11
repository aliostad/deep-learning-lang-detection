# -*- coding: UTF-8 -*-
#############################################
## (C)opyright by Dirk Holtwick, 2008      ##
## All rights reserved                     ##
#############################################

from pyxer.base import *

router = Router()
router.add_re("^content1\/(?P<name>.*?)$", controller="content1", name="_content1")
router.add("content2/{name}", controller="content2", name="_content2")
router.add("pub2", module="public2", name="_public2")

@controller
def index():
    return "/index"

@controller
def dummy():
    return "/dummy"

@controller
def default():
    return "/default"

@controller
def content1():
    return "/sub1/content1"

@controller
def content2():
    return "/sub1/content2"
