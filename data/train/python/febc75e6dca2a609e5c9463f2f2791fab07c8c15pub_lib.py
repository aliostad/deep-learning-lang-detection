#! /usr/bin/env python
# -*- coding: utf-8 -*-

"""
    Paho Publisher Library
    @author: Bin Zhang
    @email: sjtuzb@gmail.com
"""

import datetime
import json

from get_config import *

class PubLib(object):
    """docstring for PubLib"""
    def __init__(self):
        super(PubLib, self).__init__()
        config = GetConfig()
        self.broker = config.get_broker()
        self.topics = config.get_topics()

# Called when the broker responds to our connection request.
def on_connect(client, userdata, rc):
    print("Connected with result code " + str(rc))
