#!/usr/bin/env python

# Massimo Paladin
# Massimo.Paladin@cern.ch

import os
from MultipleProducerConsumer import MultipleProducerConsumer, TimeoutException
import time
from utils.Timer import Timer

import logging
logging.basicConfig()
log = logging.getLogger(__file__)

class StompTest(MultipleProducerConsumer):
    
    def __init__(self, brokerName, brokerHost, port=6163, destination='/queue/test.topic', hostcert=None, hostkey=None, timeout=15, messages=1):
        MultipleProducerConsumer.__init__(self)
        
        self.brokerName = brokerName
        self.brokerHost = brokerHost
        self.port = port
        self.destination = destination
        self.hostcert = hostcert
        self.hostkey = hostkey
        self.timeout = timeout
        self.messages = messages
        
    def setup(self):
        
        if self.hostcert and self.hostkey:
            self.setSSLAuthentication(self.hostcert, self.hostkey)
        self.createBroker(self.brokerName, self.brokerHost, self.port)
        
    def run(self):
        
        timer = Timer(self.timeout)
        
        ''' Starting consumer '''
        self.createConsumer(self.brokerName, self.destination, timer.left)
        if self.destination.startswith('/topic/'):
            time.sleep(1)
        
        ''' Creating producer and sending a message '''
        self.createProducer(self.brokerName, self.destination, timer.left)
        for i in range(self.messages):
            self.sendMessage(self.brokerName, 
                             self.destination, 
                             {'persistent':'true'}, 
                             'testing-%s' % i)
        self.waitForMessagesToBeSent(self.brokerName,
                                     self.destination,
                                     timer.left)
        
        ''' Ensuring that we received a message '''
        self.waitForMessagesToArrive(self.brokerName, self.destination, self.messages, timer.left)
        self.assertMessagesNumber(self.brokerName, self.destination, self.messages)
            
    def stop(self):
        self.destroyAllBrokers()

if __name__ == '__main__':

    log.setLevel(logging.INFO)
    logging.getLogger('MultipleProducerConsumer').setLevel(logging.INFO)
    broker = 'gridmsg001'
    brokerHost = 'gridmsg001.cern.ch'

    mbt = StompTest(broker, brokerHost, 6163)
    mbt.setup()
    
    try:
        mbt.start()
    except KeyboardInterrupt:
        print "keyboard interrupt"
    except TimeoutException, e:
        print '%s' % e
    except AssertionError, e:
        print '%s' % e
    mbt.stop()
    
    print 'Test passed!'
