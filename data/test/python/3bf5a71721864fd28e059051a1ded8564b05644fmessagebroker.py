import json
import time
from queue import Queue
from threading import Thread

from library.libmsgbus import msgbus
from library.libtree import tree
from library.libmqttbroker import mqttbroker

class msgbroker(Thread,msgbus):

    def __init__(self):
        Thread.__init__(self)

        self._mqttbroker = None

        '''
        Setup message Queues
        '''
        self._configQ = Queue()
        self._notifyQ = Queue()
       # self._msg_rxQ = Queue()
        print('Init messagebroker object')


    def run(self):

        self.setup()

        threadRun = True

        while threadRun:



            while not self._configQ.empty():
                self.on_config(self._configQ.get())

            while not self._notifyQ.empty():
          #      print('zzzzz')
          #      if self._mqttbroker:
                self.on_notify(self._notifyQ.get())

            if self._mqttbroker:
                while True:
                    (msg,ch) = self._mqttbroker.rx_data()
                    if msg:
                        self.on_data(msg)
                    else:
                        break

            time.sleep(1)

        return True

    def setup(self):
        ''''
        setup message pipes
        '''
        self.msgbus_subscribe('CONFIG', self._on_config)
        self.msgbus_subscribe('DATA_TX', self._on_notify)
        return True

    def _on_notify(self,msg):
     #   print('TTTTTTTTTTTTTTTTTT')
        self._notifyQ.put(msg)
        return True

    def _on_config(self,msg):
        self._configQ.put(msg)
        return True

    def on_config(self,cfg_msg):
        broker = cfg_msg.select('BROKER')
        if not self._mqttbroker:
         #   print('Messagebroker:: initial startup')
            self._mqttbroker = mqttbroker(broker.getTree())
            #print ('MEssagebroker: start new MQTT ',self._mqttbroker)
        else:
           # print ('MEssagebroker: New Configuration available restart broker',self._mqttbroker)
            self._mqttbroker.reconfig(broker.getTree())
            #del self._mqttbroker
            #time.sleep(0.5)
            #self._mqttbroker = mqttbroker(broker.getTree())
          #  print ('MEssagebroker: start new MQTT with updated ',self._mqttbroker)
        return True

    def on_notify(self,msg):

        msg['MESSAGE'] = self._generate_header('NOTIFY')
     #   print('messagebroker::msg broker',msg)
        self._mqttbroker.tx_data(self._dict2json(msg))
       # self.msgbus_publish('MSG_TX',self._dict2json(msg))
        return True

    def on_data_new(self,msg):
        msg = self._json2dict(msg)

        header = msg.pop('MESSAGE',None)
        if not header:
            if header:
                msg_type = header.get('TYPE',None)

                if msg_type == 'CONFIG':
                    msg_mode = header.get('MODE',None)
                    if msg_mode == 'ADD':
                        self.msgbus_publish('CFG_ADD',msg)
                    elif msg_mode == 'DEL':
                        self.msgbus_publish('CFG_DEL',msg)
                    else:
                        self.msgbus_publish('CFG_NEW',msg)

                elif msg_type == 'REQUEST':
                    self.msgbus_publish('REQUEST',msg)
                else:
                    print('Not found',msg)
        else:
            self.msgbus_publish('REQUEST',msg)

    def on_data(self,msg):
        '''
        :param msg:
        :return:

        in MESSAGE Header
         -+ TYPE = CONFIG
          -+MODE = ADD | DEL | NEW
         -+TYPE = REQUEST
          -+MODE = NONE

        '''
   #     print('ON_DATA:', msg)
        msg = self._json2dict(msg)

        msg_header = msg.get('MESSAGE',None)
        del msg['MESSAGE']

        if msg_header:
            msg_type = msg_header.get('TYPE',None)

            if msg_type == 'CONFIG':
                msg_mode = msg_header.get('MODE',None)
                if msg_mode == 'ADD':
                    self.msgbus_publish('CFG_ADD',msg)
                elif msg_mode == 'DEL':
                    self.msgbus_publish('CFG_DEL',msg)
                else:
                    self.msgbus_publish('CFG_NEW',msg)

            elif msg_type == 'REQUEST':
                self.msgbus_publish('REQUEST',msg)

            else:
                print('Not found',msg)

        return True


    def _generate_header(self,header_type):

        msg_header= {}

        if 'NOTIFY' in header_type:
            msg_header['TYPE']='NOTIFY'

        elif 'CONFIG' in header_type:
            msg_header['TYPE']='ADD'

        else:
            msg_header['TYPE']='UNKNOWN'

        msg_header['TIME']=int(time.time())

        return msg_header


    def _json2dict(self,j_data):
        return json.loads(j_data.decode('utf8'))

    def _dict2json(self,dict):
       # return str(dict)
        return json.dumps(dict)



,
    bus = msgbus()

    broker =msgbroker()
    broker.start()

    broker = {}
    test = {}
    broker['HOST']='192.168.1.117'
    broker['PORT']=1883
    broker['PUBLISH']='/TEST'
    broker['SUBSCRIBE']='/TEST'
    test['BROKER']=broker
    t = tree(test)

    bus.msgbus_publish('CONFIG',t)
    time.sleep(5)
    bus.msgbus_publish('NOTIFY',test)

    time.sleep(1)

   # broker = {}
    #test = {}
    #broker['HOST']='localhost'
    #broker['PORT']=1883
    #test['BROKER']=broker
    #t = tree(test)
    #bus.msgbus_publish('CONFIG',t)