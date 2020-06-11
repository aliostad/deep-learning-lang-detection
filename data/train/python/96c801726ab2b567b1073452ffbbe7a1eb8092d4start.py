#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
    Starter for the startuppoker spectator.

    :copyright: (c) 2011 by it-agile GmbH
    :license: BSD, see LICENSE for more details.
"""
import sys
sys.path.append('../')
from startuppoker_spectator import spectator
from startuppoker_repository import sqlite_repository as repository

debug = False

if __name__ == '__main__':
    spectator.repository = repository
    try:
        import local_settings
        debug = local_settings.debug
        repository.instance = local_settings.repository_instance
    except ImportError:
        pass
    app = spectator.app
    app.debug = debug
    app.run('127.0.0.1', int(sys.argv[1]))
