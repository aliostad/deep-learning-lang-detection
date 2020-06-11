# encoding=utf-8
'''
# @file broker.py
# @brief 
# @author zhenpeng
# @version 1.0.0
# @date 2012-10-30
'''
import sys
sys.path.append('..')
from common.MetaManager import MetaManager
from common.Configure import Configure
from lib.BrokerServer import BrokerServer
import logging
import platform
import socket

class Broker():
    def __init__(self, conf_path = ''):
        logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level = logging.DEBUG)
        self.conf = Configure(conf_path).conf
        self.meta = MetaManager(self.conf['meta-server'], self.conf['meta-root'])
        logging.info('broker init OK, conf: %s' % str(self.conf))
        logging.info('broker init OK, zk addr: %s, zk root: %s' % (self.conf['meta-server'], self.conf['meta-root']))

    def register_to_serve(self):
        node_path = '/Broker'
        node_value = "%s:%s" % (socket.gethostbyname(platform.node()), self.conf['listen-port'])
        # make sure node exist
        self.meta.create_node(node_path)
        # register service
        if self.meta.register_node(path = node_path, value = node_value):
            logging.info('register broker OK, addr %s' % node_value)
            return True
        else:
            logging.error('register broker failed, addr %s' % node_value)
            return False

    def start_rest_server(self):
        rest_server = BrokerServer(self.conf)
        rest_server.run()
        return True

    def run(self):
        logging.info('Broker running...')
        # register to serve
        if not self.register_to_serve():
            logging.error('register borker failed, quit')
            quit()
        # start rest server
        if not self.start_rest_server():
            logging.error('start rest server failed, quit')
            quit()


if __name__ == '__main__':
    # load conf & init
    broker = Broker('./conf/broker.conf')
    # start broker server
    broker.run()
