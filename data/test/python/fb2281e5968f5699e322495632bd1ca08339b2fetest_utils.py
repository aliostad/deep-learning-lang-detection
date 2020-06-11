# -*- coding: utf-8 -*-
"""
osnap.stories.tests.test_models
===============================
These test our industry-standard `utils.py` file full of random stuff.

:copyright: (C) 2013 Matthew Frazier
:license:   GNU GPL version 2 or later, see LICENSE for details
"""
from __future__ import unicode_literals
from functools import wraps

from django.test import SimpleTestCase
from django.utils.six import text_type

from ..utils import decorated_view

def stringify_inputs(f):
    @wraps(f)
    def stringify(arg):
        return f(text_type(arg))
    return stringify


class BaseDispatcher(object):
    "An artificial example, to be sure."
    def dispatch(self, v):
        return self.delegated_method(v)


class UtilityTests(SimpleTestCase):
    def test_decorated_view(self):
        # Key point: it just decorates dispatch(), without caring
        # about whether it's an actual view.
        @decorated_view(stringify_inputs)
        class DispatchTo(object):
            def dispatch(self, v):
                return v

        dispatch = DispatchTo()
        self.assertEquals(dispatch.dispatch(32), "32")
        self.assertEquals(DispatchTo.dispatch(dispatch, 32), "32")

    def test_decorated_view_subclass(self):
        @decorated_view(stringify_inputs)
        class PrefixDispatcher(BaseDispatcher):
            def delegated_method(self, v):
                return "spam-" + v

        dispatch = PrefixDispatcher()
        self.assertEquals(dispatch.dispatch(32), "spam-32")
        self.assertEquals(PrefixDispatcher.dispatch(dispatch, 32), "spam-32")

    def test_decorated_view_errors(self):
        with self.assertRaises(TypeError):
            # Well, we have a class with no 'dispatch' method right here...
            decorated_view(stringify_inputs)(UtilityTests)

