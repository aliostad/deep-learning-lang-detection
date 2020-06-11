#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Author : Patrick Charron
# Email : patrick.charron.pc@gmail.com
# Description : Message Broker Client
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import importlib
import os
import pkgutil
import logging

from brokerc import basebroker

DEBUG_LEVEL_CRITICAL = logging.CRITICAL
DEBUG_LEVEL_ERROR = logging.ERROR
DEBUG_LEVEL_WARNING = logging.WARNING
DEBUG_LEVEL_INFO = logging.INFO
DEBUG_LEVEL_DEBUG = logging.DEBUG

def list_brokers():
    return [f[1] for f in pkgutil.iter_modules([os.path.dirname(__file__)])]

def test(broker_name=None, driver_name=None):
    report = {}
    if broker_name:
        report[broker_name] = _test(broker_name, driver_name)
    else:
        for broker_name in list_brokers():
            report[broker_name] = _test(broker_name, driver_name)
    return report

def _test(broker_name, driver_name):
    report = {}
    try:
        broker = create(broker_name)
    except Exception as e:
        report['status'] = 'Fail'
        report['error'] = str(e)
        report['drivers'] = {}
    else:
        report['status'] = 'Succeed'
        report['error'] = 'None'
        report['drivers'] = broker.test(driver_name)
    return report

def create(broker_name):
    #Load broker module
    if broker_name not in list_brokers():
        raise ValueError("Broker : " + str(broker_name) + " : is not valid")
    try:
        broker_module = importlib.import_module("." + broker_name, "brokerc.brokers")
    except Exception as e:
        raise ImportError("Impossible to load : " + str(broker_name) + " : " + str(e))
    broker = basebroker.BaseBroker(broker_name, broker_module.__drivers__)
    return broker
