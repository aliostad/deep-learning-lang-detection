# -*- coding: utf-8 -*-
"""Buildbot Controller"""

from tg import expose, flash, require, url, request, redirect
from pylons.i18n import ugettext as _, lazy_ugettext as l_
from repoze.what import predicates

from erebot.lib.base import BaseController

__all__ = ['BuildbotController']

class BuildbotController(BaseController):
    """
    The root controller for the Erebot application.
    """
    @expose('erebot.templates.buildbot.index')
    def index(self):
        """Handle the front-page."""
        return dict()

