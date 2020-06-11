#!/usr/bin/env python
# -*- coding: utf-8; py-indent-offset:4 -*-
from __future__ import (absolute_import, division, print_function,
                        unicode_literals)

import six

from .metabase import MetaParams


class SizerBase(six.with_metaclass(MetaParams, object)):

    params = (('broker', None,),)

    def getsizing(self, data, broker=None):
        broker = broker or self.params.broker
        return self._getsizing(broker.getcommissioninfo(data),
                               broker.getcash())

    def _getsizing(self, comminfo, cash):
        raise NotImplementedError

    def setbroker(self, broker):
        self.params.broker = broker

    def getbroker(self):
        return self.params.broker


class SizerFix(SizerBase):
    params = (('stake', 1),)

    def _getsizing(self, comminfo, cash):
        return self.params.stake

    def setsizing(self, stake):
        self.params.stake = stake
