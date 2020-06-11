#! /usr/bin/env python
# -*- coding: utf-8 -*-

"""
    main program of the publisher
    @author: Bin Zhang
    @email: sjtuzb@gmail.com
"""

import paho.mqtt.client as mqtt

from get_config import *
from pub_lib import *

def main():
    config = GetConfig()
    broker = config.get_broker()
    topics = config.get_topics()
    broker_url = broker["url"]
    broker_port = broker["port"]
    broker_username = broker["username"]
    broker_password = broker["password"]

    client = mqtt.Client()
    client.username_pw_set(broker_username, broker_password)

    client.on_connect = on_connect

    client.connect(broker_url, broker_port, 60)

    client.loop_start()

    message = {}
    test_data = [{"device": "meter0", "timestamp": 1428928106556, "id": 3, "minimum": 111, "average": 222, "maximum": 333}, {"device": "meter0", "timestamp": 1428928106778, "id": 4, "minimum": 222, "average": 444, "maximum": 666}]
    message = test_data
    message_json = json.dumps(message)
    for key in topics.keys():
        client.publish(topics[key]["topic"], message_json, topics[key]["qos"])

if __name__ == '__main__':
    main()
