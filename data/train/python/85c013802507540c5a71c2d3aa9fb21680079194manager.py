#coding=utf8

import logging
from binascii import hexlify
import time
import zmq.green as zmq
from .base import Base
from .resource import ResourceManager
from .utils.function import split_address
from .utils.timer import Timer
from .protocol import C_READY, C_REQUEST, C_REPLY, C_HEARTBEAT, C_DISCONNECT, C_EXCEPTION, C_ERROR, C_SETUP, C_REGISTER
from .serializer import loads, dumps





CONFIG = {
    'WORKER': {
        'HEARTBEAT_LIVENESS': 5,
        'HEARTBEAT_INTERVAL': 1000
        # 'ctrl_uri'
        # 'broker_uri'
    },
    'CLIENT': {
        'HEARTBEAT_LIVENESS': 5,
        'HEARTBEAT_INTERVAL': 1000
        # 'ctrl_uri'
        # 'broker_uri'
    },
    'BROKER': {
        'HEARTBEAT_LIVENESS': 5,
        'HEARTBEAT_INTERVAL': 1000
        # 'ctrl_uri'
        # 'broker_uri'
    }
}





class Manager(Base):

    HEARTBEAT_LIVENESS = 5
    HEARTBEAT_INTERVAL = 1000
    HEARTBEAT_EXPIRY = HEARTBEAT_INTERVAL * HEARTBEAT_LIVENESS

    def __init__(self, identity, conf_uri, ctrl_uri):
        self.identity = identity
        self.started = False
        self.conf_uri = conf_uri
        self.ctrl_uri = ctrl_uri

        self._cur_worker_idx = 0
        self._cur_client_idx = 0

        self._resmgr = ResourceManager()

        self.heartbeat_at = time.time() + 1e-3*self.HEARTBEAT_INTERVAL

        self.init()        


    def init(self):
        self._clients = {}
        self._workers = {}
        self._brokers = {}


        self.ctx = zmq.Context()
        self.conf_rut = self.ctx.socket(zmq.ROUTER)
        self.conf_rut.bind(self.conf_uri)
        self.ctrl_pub = self.ctx.socket(zmq.PUB)
        self.ctrl_pub.bind(self.ctrl_uri)

        self.state_sub = self.ctx.socket(zmq.SUB)
        self.state_sub.setsockopt_string(zmq.SUBSCRIBE, u'')

        self.poller = zmq.Poller()
        self.poller.register(self.conf_rut, zmq.POLLIN)
        self.poller.register(self.state_sub, zmq.POLLIN)

    def publish_control(self, topic, msg):
        logging.debug('publish control %s => %s' %  (topic, msg))
        to_send = [topic, self.identity, dumps(msg)]
        self.ctrl_pub.send_multipart(to_send)


    def heartbeat(self):

        bw = []
        peers = self._resmgr.peers
        for bid in peers:
            broker = peers[bid]
            if not broker.isalive():
                bw.append((bid, broker))

        for bid, broker in bw:
            self.publish_control('broker.failure', {'identity': bid})
            self._resmgr.remove_peer(bid)

        # send to broker
        # self.mgrsock.send_multipart([C_HEARTBEAT, 'BROKER', self.identity])





    def get_broker_uri(self, role):
        m = None
        broker = None
        peers = self._resmgr.peers
        for bid in peers:
            b = peers[bid]
            if role == 'WORKER':
                num = b.worker_total
            elif role == 'CLIENT':
                num = b.client_total
            else:
                break

            if m is None or m > num:
                m = num
                broker = b

        if not broker:
            return None

        if role == 'WORKER':
            addr = broker.worker_uri
        else:
            addr = broker.client_uri

        return addr




    def get_conf(self, role, identity):
        conf = CONFIG.get(role).copy()
        conf['ctrl_uri'] = self.ctrl_uri

        if role == 'WORKER':
            conf['broker_uri'] = self.get_broker_uri(role)
        elif role == 'CLIENT':
            conf['broker_uri'] = self.get_broker_uri(role)
        elif role == 'BROKER':
            pass

        if role != 'BROKER':
            print 'get_broker %s %s' % (identity, conf['broker_uri'])

        return conf

    def send_reply(self, addr, msg):
        to_send = [addr, b'']
        to_send.extend(msg)
        self.conf_rut.send_multipart(to_send)

    def on_conf_message(self, sender, msg):
        # address, empty, request = socket.recv_multipart()

        # print msg
        cmd = msg.pop(0)

        if cmd == C_REGISTER:
            role = msg.pop(0)
            identity = msg.pop(0)
            print role == 'BROKER'
            conf = {}

            if role == 'WORKER':
                service = msg[0]
                self._resmgr.add_worker(identity, service)
                # info = {
                #     'service': msg[0]
                # }
                # self._workers[identity] = info
            elif role == 'CLIENT':
                self._resmgr.add_client()
                # info = {
                #     'service': msg and msg[0] or None
                # }
                # self._clients[identity] = info
            elif role == 'BROKER':
                print msg
                info = {
                    'address': identity,
                    'client_uri' : msg[0],
                    'worker_uri' : msg[1],
                    'cloudfe_uri' : msg[2],
                    'statebe_uri' : msg[3],
                    'services': {}, #wid service_name
                    'workers': 0,
                    'clients': 0,
                    'lifetime': self.HEARTBEAT_EXPIRY
                }                
                self._resmgr.add_peer(identity, **info)

                # self._brokers[identity] = info

                ob = []
                peers = self._resmgr.peers
                for pid in peers:
                    if pid != identity:
                        p = peers[pid]
                        ss = {}
                        for s in p.services:
                            ss[s] = p.services[s]

                        data = {
                            'identity': pid,
                            'address':p.address,
                            'cloudfe_uri' : p.cloudfe_uri,
                            'statebe_uri' : p.statebe_uri,
                            'services' : ss
                        }
                        ob.append(data)
                conf['other_brokers'] = ob

                # 连接到broker的statebe，用于接收broker的状态信息
                self.state_sub.connect(info['statebe_uri'])

                data = {
                    'identity': identity,
                    'cloudfe_uri' : msg[2],
                    'statebe_uri' : msg[3]
                }
                
                # notice broker
                # self.ctrl_pub.send_multipart(['control.new_broker', self.identity, pack(data)])
                self.publish_control('broker.join', data)

            cfg = self.get_conf(role, identity)

            conf.update(cfg)


            msg = [C_SETUP, dumps(conf)]
            self.send_reply(sender, msg)

            print "%s %s %s connected" % (sender, role, identity)

        elif cmd == C_HEARTBEAT:
            role, identity = msg
            if role == 'BROKER':
                # self._brokers[identity]['expiry'] = time.time() + 1e-3*self.HEARTBEAT_EXPIRY
                peer = self._resmgr.get_peer(identity)
                if peer:
                    peer.on_heartbeat()



    def on_state_message(self, topic, sender, msg):
        msg = loads(msg)
        print 'on_state_message', topic, sender, msg
        if topic == 'services.status':
            self._resmgr.update_peer_service_status(sender, msg)
        elif topic.startswith('worker.'):
            # b = self._brokers.get(sender)
            # if not b:
            #     logging.warn(u'cannt find broker %s' % sender)
            #     return
            waddr = msg[0]
            service = msg[1]

            if topic == 'worker.ready':
                self._resmgr.add_peer_worker(sender, waddr, service)
                # b['workers'] += 1
                # wid = msg[0]
                # service = msg[1]
                # if service not in b['services']:
                #     b['services'][service] = set()
                #     b['services'][service].add(wid)
                # else:
                #     b['services'][service].add(wid)
            elif topic == 'worker.disconnected':
                self._resmgr.remove_peer_worker(sender, waddr, service)
                # b['workers'] -= 1
                # wid = msg[0]
                # service = msg[1]
                # try:
                #     b['services'][service].remove(wid)
                # except:
                #     pass
        elif topic.startswith('client.'):
            b = self._brokers.get(sender)
            if topic == 'client.connected':
                pass
            elif topic == 'client.disconnected':
                pass


    def start(self):
        self.started = True

        logging.info("I: start manager:  <%s>   <%s>" % (self.conf_uri, self.ctrl_uri))
        self._timer = Timer(self.heartbeat, self.HEARTBEAT_INTERVAL)

        while self.started:
            try:
                events = dict(self.poller.poll(self.HEARTBEAT_INTERVAL))
            except zmq.ZMQError:
                logging.exception('zmq.ZMQError')
                continue
            except KeyboardInterrupt:
                break                

            if self.conf_rut in events:
                msg = self.conf_rut.recv_multipart()
                # print 'conf recv', msg
                sender, msg = split_address(msg)
                self.on_conf_message(sender[0], msg)
            if self.state_sub in events:
                topic, sender, msg = self.state_sub.recv_multipart()
                self.on_state_message(topic, sender, msg)



    def stop(self):
        self.started = False
        self._timer.stop()

        