#coding=utf8

import logging
from gevent import monkey
monkey.patch_all()
from zservice import CloudBroker

logging.basicConfig(format="%(asctime)s %(message)s", datefmt="%Y-%m-%d %H:%M:%S", level=logging.DEBUG)

uris = {}
uris['client_uri']  = 'tcp://127.0.0.1:5003'
uris['worker_uri']  = 'tcp://127.0.0.1:5004'
uris['cloudfe_uri'] = 'tcp://127.0.0.1:6003'
uris['statebe_uri'] = 'tcp://127.0.0.1:7004'
uris['manager_uri'] = 'tcp://localhost:9999'

broker = CloudBroker('broker2', **uris)
broker.register()
broker.start()
