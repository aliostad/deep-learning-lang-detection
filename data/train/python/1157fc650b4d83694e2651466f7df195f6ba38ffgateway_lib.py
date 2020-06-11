#! /usr/bin/env python
# -*- coding: utf-8 -*-

"""
    Paho Publisher Library for Gateway
    @author: Bin Zhang
    @email: sjtuzb@gmail.com
"""

import paho.mqtt.client as mqtt

from get_config import *
from pub_lib import *

def gateway_config():
    config = GetConfig()
    broker = config.get_broker()
    global topics
    topics = config.get_topics()
    broker_url = broker["url"]
    broker_port = broker["port"]
    broker_username = broker["username"]
    broker_password = broker["password"]

    global client
    client = mqtt.Client()
    client.username_pw_set(broker_username, broker_password)

    client.on_connect = on_connect

    client.connect(broker_url, broker_port, 60)

    client.loop_start()

def gateway_puber(message):
    global topics
    global client
    message_json = json.dumps(message)
    for key in topics.keys():
        client.publish(topics[key]["topic"], message_json, topics[key]["qos"])
