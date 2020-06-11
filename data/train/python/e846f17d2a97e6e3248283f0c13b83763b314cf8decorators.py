'''
Copyright (c) 2015-2016 Skylable Ltd. <info-copyright@skylable.com>
License: see LICENSE.md for more details.
'''

from django.contrib import messages
from django.http import Http404
from django.shortcuts import redirect
from django.utils.translation import ugettext_lazy as _

from .views import UserViewMixin


def anonymous_only(cls):
    """Decorator for Views that can only be accessed by anonymous users."""
    dispatch = cls.dispatch

    def wrapped(self, *args, **kwargs):
        if not self.request.user.is_authenticated():
            return dispatch(self, *args, **kwargs)
        messages.warning(self.request, _(
            "You can't do this while logged in."))
        return redirect('home')

    wrapped.__doc__ = dispatch.__doc__
    cls.dispatch = wrapped
    return cls


def regular_user_only(cls):
    """Decorator for Views that can only be performed on regular users."""
    assert issubclass(cls, UserViewMixin)
    dispatch = cls.dispatch

    def wrapped(self, *args, **kwargs):
        if self.user and not self.user.is_reserved:
            return dispatch(self, *args, **kwargs)
        raise Http404()

    wrapped.__doc__ = dispatch.__doc__
    cls.dispatch = wrapped
    return cls
