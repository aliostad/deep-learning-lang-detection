# coding=utf-8
import json
import sys
import os
from kazoo.client import KazooClient

zk = KazooClient(hosts=sys.argv[1], read_only=True)
zk.start()

broker_list = ""
children = zk.get_children('/brokers/ids')
for i in children:
    data, stat = zk.get('/brokers/ids/' + i)
    data = json.loads(data)
    if broker_list != "":
        broker_list += ","
    broker_list += data['host'].encode('utf8') + ":" + str(data['port'])

data, stat = zk.get('/brokers/ids/0')
zk.stop()
data = json.loads(data)
print broker_list
