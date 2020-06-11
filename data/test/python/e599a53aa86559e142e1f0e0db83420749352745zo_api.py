#encoding=utf-8
import logging
import zmq
from binascii import hexlify
__version__ = '0.1'

FLG_CLIENT = 'ZOCLIENT_' + __version__
FLG_SERVICE = 'ZOSERVICE_' + __version__

M_READY         = '\x01'
M_REQUEST       = '\x02'
M_REPLY         = '\x03'


class ZOClient(object):
    broker = None
    ctx = None
    client = None
    poller = None

    timout = 2500
    retry = 3
    verbose = False

    def __init__(self, broker, verbose = False):
        self.broker = broker
        self.verbose = verbose
        self.ctx = zmq.Context()
        self.poller = zmq.Poller()
        logging.basicConfig(format="%(asctime)s %(message)s", datefmt="%Y-%m-%d %H:%M:%S", level = logging.INFO)

        self.connect_to_broker()

    def connect_to_broker(self):
        if self.client:
            self.poller.unregister(self.client)
            self.client.close()

        self.client = self.ctx.socket(zmq.REQ)
        self.client.connect(self.broker)
        self.poller.register(self.client, zmq.POLLIN)

        if self.verbose:
            logging.info('connecting to broker : ' + self.broker)

    """Sync call"""
    def send(self, service, msg):
        if not isinstance(msg,list):
            msg = [msg]

        request = [FLG_CLIENT, service] + msg

        if self.verbose:
            logging.info('sending request to broker :' +  self.broker +' ' +service)

        reply = None

        retry = self.retry
        while retry > 0:
            self.client.send_multipart(request)

            try:
                socks = self.poller.poll(self.timout)
            except:
                break

            if socks:
                msg = self.client.recv_multipart()
                if self.verbose:
                    logging.info("received reply: " + str(msg))

                assert len(msg) >= 3 # control service msg
                
                header = msg.pop(0)
                assert header == FLG_CLIENT

                reply_service = msg.pop(0)
                assert reply_service == service

                reply = msg
                break
            else:
                if retry > 0:
                    logging.warn("no reply, reconnecting...")
                    self.connect_to_broker()
                else:
                    logging.warn("server down...")
                    break
                retry -= 1
        return reply

    def destroy(self):
        self.ctx.destroy()


class ZOSerivce(object):
    broker = None
    ctx = None
    poller = None

    timeout = 2500
    verbose = False

    reply_to = None # reply address
    service = None

    worker = None

    def __init__(self, broker, service, verbose=False):
        self.broker = broker
        self.service = service
        self.verbose = verbose

        self.ctx = zmq.Context()
        self.poller = zmq.Poller()

        logging.basicConfig(format="%(asctime)s %(message)s", datefmt="%Y-%m-%d %H:%M:%S",
                level=logging.INFO)

        self.connect_to_broker()

    def connect_to_broker(self):
        if self.worker:
            self.poller.unregister(self.worker)
            self.worker.close()
        self.worker = self.ctx.socket(zmq.DEALER)
        self.worker.connect(self.broker)
        self.poller.register(self.worker, zmq.POLLIN)
        logging.warn('connect to broker')
        # register service
        self.send_to_broker(M_READY, self.service, [])

    def send_to_broker(self,cmd, service = None, msg =None):
        if msg is None:
            msg = []
        elif not isinstance(msg, list):
            msg = [msg]
        
        if service:
            msg = [service] + msg

        msg = ['', FLG_SERVICE, cmd] + msg
        self.worker.send_multipart(msg)

    def reply(self, reply_for_last_req):
        if reply_for_last_req is not None:
            if self.verbose:
                logging.info('sending reply to : ' + hexlify(self.reply_to))
            reply = [self.reply_to, ''] + reply_for_last_req
            self.send_to_broker(M_REPLY, None,  msg=reply)
    
    def recv(self,reply_for_last_req):
        self.reply(reply_for_last_req)
        while True:
            ###  recv ##    
            socks = self.poller.poll(self.timeout)
            
            if socks:
                msg = self.worker.recv_multipart()
                assert len(msg) >= 3

                empty = msg.pop(0)
                assert empty == ''

                header = msg.pop(0)
                assert header == FLG_SERVICE

                cmd = msg.pop(0)
                if cmd == M_REQUEST:
                    self.reply_to = msg.pop(0)
                    assert msg.pop(0) == ''
                    return msg

        logging.warn('killing service')
        return None

    def destroy(self):
        self.ctx.destroy(0)