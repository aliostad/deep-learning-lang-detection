'''
Created on Jan 30, 2015

@author: AlirezaF
'''
from random import *
from entities.Node import Vendor, Customer, Broker

class Network():
    '''
    Networks concluding customers, vendors and broker nodes.
    In a Networks nodes can pass message to eachother and make a request for
    purchasing scrips, transfering a secrent and other stuff.
    '''


    def __init__(self, num_of_vendors = 1, num_of_customers = 1):
        '''
        Creates some vendors and customers node and and everything needed
        for network to b do its tasks
        '''
        self.last_id = 100
        self.vendors = [Vendor(self.generate_id()) for i in num_of_vendors]
        self.customers = [Customer(self.generate_id()) for i in num_of_customers]
        self.broker = Broker(self.generate_id())
        
    def generate_id(self):
        self.last_id += 1
        return self.last_id
    
    def broker_id(self):
        return self.broker.id    