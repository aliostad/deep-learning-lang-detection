#!/usr/bin/env python
# -*- coding: utf-8 -*-

#
# Company: WONDROUS
# Created by: John Zimmerman
#
# ADMIN_ROUTES.PY 
#

"""
    Create admin routes here, and they get
    returned into __init__.py admin_app()

    * NOTE: These have a route prefix of '/_admin'
        ex 1. '/' --> '/_admin/'
        ex 2. '/login/' --> '/_admin/login/'
"""

def build_admin_routes(config):

    # --- ADMIN PURPOSES ONLY ---
    config.add_route('_admin_handler',                       '/')
    config.add_route('_admin_handler_login',                 '/login/')

    config.add_route('_admin_handler_manage_admin',          '/manage/admin/')
    config.add_route('_admin_handler_stats',                 '/stats/')
    config.add_route('_admin_handler_manage_reported',       '/manage/reported/')
    config.add_route('_admin_handler_manage_users',          '/manage/users/')
    config.add_route('_admin_handler_manage_users_specific', '/manage/users/{user_id}/')

    config.add_route('_admin_ajax_delete_content',           '/ajax/delete_content/')
    config.add_route('_admin_ajax_ban_user',                 '/ajax/ban_user/')

    return config