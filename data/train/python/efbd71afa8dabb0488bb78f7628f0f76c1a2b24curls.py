# -*- coding: utf-8 -*-
# vim: sw=4 ts=4 fenc=utf-8 et
# ==============================================================================
# Copyright © 2010 UfSoft.org - Pedro Algarvio <ufs@ufsoft.org>
#
# License: BSD - Please view the LICENSE file for additional information.
# ==============================================================================

from werkzeug.routing import Map, Rule, Submount

def get_channel_rules():
    rules = [Rule('/', endpoint='channel.index')]
    tmp = '/'
    for digits, part in ((4, 'year'), (2, 'month'), (2, 'day')):
        tmp += '<int(fixed_digits=%d):%s>/' % (digits, part)
        rules.extend([
            Rule(tmp, defaults={'page': 1}, endpoint='channel.browse'),
            Rule(tmp + 'page/<int:page>', endpoint='channel.browse'),
        ])
    return rules

urls_map = Map([
    Rule('/', endpoint='index'),
    Submount('/account', [
        Rule('/login', endpoint='account.login'),
        Rule('/logout', endpoint='account.logout'),
        Rule('/delete', endpoint='account.delete'),
        Rule('/profile', endpoint='account.profile'),
        Rule('/dashboard', endpoint='account.dashboard'),
        Rule('/__rpx__', endpoint='account.rpx'),
        Rule('/register', endpoint='account.register'),
        Rule('/__rpx_providers__', endpoint='account.rpx_providers'),
        Rule('/activate', defaults={'key': None}, endpoint='account.activate'),
        Rule('/activate/<string:key>', endpoint='account.activate')
    ]),
    Submount('/network', [
        Rule('/', endpoint='network.index'),
        Rule('/', endpoint='network.index2'),
        Submount('/<string:network>', [
            Rule('/', endpoint='network.channels'),
            Submount('/<string:channel>', get_channel_rules())
        ]),
    ]),
    Submount('/admin', [
        Rule('/', endpoint='admin.index'),
        Submount('/manage', [
            Rule('/', endpoint='admin.manage.groups'),
            Submount('/groups', [
                Rule('/', endpoint='admin.manage.groups'),
                Rule('/new', endpoint='admin.manage.groups.new'),
                Rule('/edit/<int:group_id>',
                     endpoint='admin.manage.groups.edit'),
                Rule('/delete/<int:group_id>',
                     endpoint='admin.manage.groups.delete'),
            ]),
            Submount('/users', [
                Rule('/', endpoint='admin.manage.users'),
                Rule('/new', endpoint='admin.manage.users.new'),
                Rule('/edit/<int:user_id>',
                     endpoint='admin.manage.users.edit'),
                Rule('/delete/<int:user_id>',
                     endpoint='admin.manage.users.delete'),
            ]),
            Submount('/networks', [
                Rule('/', endpoint='admin.manage.networks'),
                Rule('/new', endpoint='admin.manage.networks.new'),
                Rule('/edit/<int:network_id>',
                     endpoint='admin.manage.networks.edit'),
                Rule('/delete/<network_id>',
                     endpoint='admin.manage.networks.delete'),
            ]),
            Submount('/channels', [
                Rule('/', endpoint='admin.manage.channels'),
                Rule('/new', endpoint='admin.manage.channels.new'),
                Rule('/edit/<int:channel_id>',
                     endpoint='admin.manage.channels.edit'),
                Rule('/delete/<channel_id>',
                     endpoint='admin.manage.channels.delete'),
            ]),
            Submount('/bots', [
                Rule('/', endpoint='admin.manage.bots'),
                Rule('/new', endpoint='admin.manage.bots.new'),
                Rule('/edit/<int:bot_id>',
                     endpoint='admin.manage.bots.edit'),
                Rule('/delete/<bot_id>',
                     endpoint='admin.manage.bots.delete'),
            ]),
        ]),
        Submount('/options', [
            Rule('/', endpoint='admin.options.basic'),
            Rule('/advanced', endpoint='admin.options.advanced'),
            Rule('/rpxnow', endpoint='admin.options.rpxnow'),
            Rule('/gravatar', endpoint='admin.options.gravatar'),
            Rule('/email', endpoint='admin.options.email'),
            Rule('/cache', endpoint='admin.options.cache'),
        ])
    ]),
    Rule('/_static/<string:path>', endpoint='static', build_only=True)
], default_subdomain='', charset='utf-8', strict_slashes=True)
