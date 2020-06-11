#!/usr/bin/env python
# coding = utf-8


import functools
import base64
import traceback

from flask import request
from flask import g
from eagle import controller as ctlr

def controller_deco(func):
    """add eagle controller param"""

    @functools.wraps(func)
    def wrapper(*argv, **kwgs):
        eagle_controller = _get_eagle_controller()
        kwgs["eagle_controller"] = eagle_controller
        return func(*argv, **kwgs)

    return wrapper


def _get_eagle_controller():
    eagle_controller=ctlr.EagleController()

    return eagle_controller
