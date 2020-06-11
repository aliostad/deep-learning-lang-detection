#!/usr/bin/env python
#-*- coding:utf-8 -*-

###################################################
#
# Create by:  Yuanji
# Date Time:  2015-11-20 14:42:58
# Content:
# Notice :
#
###################################################

import yaml
import base64
import tornado.web
import tornado.ioloop
import logging.config
from settings import *
import tornado.httpserver
import random, time, os, sys, socket
from handlers.showhandler import *
from handlers.clickhandler import *
from scheduler.countercache import *
from scheduler.createcache import *
from handlers.cookiehandler import *
#from scheduler.distributor import Distributor, Requester
from tornado.ioloop import  IOLoop
from utils.kfconnect import KafkaCon
from priceparser.priceparser import AdxPriceParser

RESPONSE_BLANK = """(function(){})();"""
REAL_IP = 'X-Real-Ip' # Need to config in nginx
REMOTE_IP = 'remote_ip'
REFERER = 'Referer'
USER_AGENT = 'User-Agent'


def urlsafe_b64encode(string):
    encoded = base64.urlsafe_b64encode(string)
    return encoded.replace( '=', '')

def urlsafe_b64decode(s):
    mod4 = len(s) % 4
    if mod4:
        s += ((4 - mod4) * '=')
    return base64.urlsafe_b64decode(str(s))


class DefaultHandler(tornado.web.RequestHandler):
    def get(self, *args, **kwargs):
        logger.debug( self.request )
        self.write(RESPONSE_BLANK)

    
class Application(tornado.web.Application):
    def __init__(self, broker):
        handlers = [
            (r'/v',SuperShowHandler, dict(broker = broker)),
            (r'/s',SuperShowHandler, dict(broker = broker)),
            (r'/click',SuperClickHandler, dict(broker = broker)),
            (r'/c',SuperClickHandler, dict(broker = broker)),
            (r'/wbshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/wbclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/gdtshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/gdtclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/inmoshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/inmoclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/soshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/soclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/tshow',SuperShowHandler, dict(broker = broker)),
            (r'/tclick',SuperClickHandler, dict(broker = broker)),
            (r'/ayclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/ayshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/ykclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/ykshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/mgclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/mgshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/amshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/amclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/tdshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/tdclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/saxshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/saxclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/besshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/besclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/jxshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/jxclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/mzshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/mzclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/gyshow.*',SuperShowHandler, dict(broker = broker)),
            (r'/gyclick.*',SuperClickHandler, dict(broker = broker)),
            (r'/(.*)',DefaultHandler)
        ]

        tornado.web.Application.__init__(self,handlers)

class HttpLoop(object):
    def __init__(self, broker):
        self.broker = broker
        self.port = broker.server_port
        pass
    def listen(self):
        try:
            http_server = tornado.httpserver.HTTPServer(Application(broker),xheaders=True)
            http_server.listen(self.port)
            return True
        except Exception, e:
            print e
            return False

    def bind(self):
        try:
            http_server = tornado.httpserver.HTTPServer(Application(broker),xheaders=True)
            http_server.bind(self.port)
            http_server.start(num_processes=8)    
            return True
        except Exception, e:
            print e
            return False

    def loop(self):
        tornado.ioloop.IOLoop.instance().start()

class Broker(object):
    def __init__(self):
        self.path = ''
        self.server_port = None
        self.cookie = CookieHanlder()
        self.countercache = CounterCache()
        self.createcache =  CreateCache()
        #self.dist = Distributor()
        #self.requester = Requester()
        self.adxPriceParser = AdxPriceParser()
        self.msg_server = KafkaCon()
        self.database = Database(redis_conf = REDISEVER, password = STATUS_REDIS_PASS)

    def daemonize(self):
        pid = os.fork()
        if pid < 0:
            os._exit(1)
        if pid > 0:
            os._exit(0)

        os.umask(0)
        os.setsid()

        pid = os.fork()
        if pid < 0:
            os._exit(1)
        if pid > 0:
            os._exit(0)

        for i in range(0,100):
            try:
                os.close(i)
            except Exception, e:
                pass
        file('/dev/null','r')
        file('/dev/null','a+')
        file('/dev/null','a+')

    def succ(self):
        if not MULT_PROCESS_MODEL:
            sock_file = '%s/sock' % self.path
            s = socket.socket(socket.AF_UNIX,socket.SOCK_DGRAM)
            s.sendto('True',sock_file)
            s.close()

    def fail(self):
        if not MULT_PROCESS_MODEL:
            sock_file = '%s/sock' % self.path
            s = socket.socket(socket.AF_UNIX,socket.SOCK_DGRAM)
            s.sendto('False',sock_file)
            s.close()

    def pid_file_init(self):
        pid_path = '%s/pid' % self.path
        pid_file = '%s/log%u.pid' % (pid_path,int(self.server_port))
        f = open(pid_file,'w')
        f.write('%u\n' % self.pid)
        f.close()

if __name__ == '__main__':
    if 1:
        path = os.path.abspath(os.path.dirname(__file__))
        broker = Broker()
        broker.path = path
        broker.server_port = int(sys.argv[1])
        
        broker.pid = os.getpid()
        if not MULT_PROCESS_MODEL:
            broker.pid_file_init()
   
        # Start HttpSock Thread
        http = HttpLoop(broker)
        sFlag = False
        if not MULT_PROCESS_MODEL:
            sFlag = http.listen()
        else:
            sFlag = http.bind()
        if not sFlag:
            broker.fail()
            os._exit(1)
        # start counter cache
        IOLoop.current().add_callback(broker.countercache.queueMsgGet)
        broker.countercache.start()
        broker.succ()
        logging.config.dictConfig(yaml.load(open('logging.yaml', 'r')))
        http.loop()
    #except Exception, e:
    #    print e
    #    broker.fail()
    #    os._exit(1)
        

