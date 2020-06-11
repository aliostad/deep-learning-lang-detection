#!/usr/bin/env python
# -*- coding: utf-8 -*-

from collections import defaultdict


class Broker(object):
    route = defaultdict(list)

    @classmethod
    def pub(cls, topic, *args, **kwargs):
        funcs = cls.route[topic]
        for func in funcs:
            func(*args, **kwargs)

    @classmethod
    def sub(cls, topic, func):
        funcs = cls.route[topic]
        if func in funcs:
            return

        funcs.append(func)


def hello_to(who):
    print 'greeting, {0}'.format(who)


def ask(who):
    print 'is that {0}?'.format(who)


Broker.sub('meet', ask)
Broker.sub('meet', hello_to)

Broker.pub('meet', 'World')

print '-' * 20

Broker.pub('meet', 'Ralph')
