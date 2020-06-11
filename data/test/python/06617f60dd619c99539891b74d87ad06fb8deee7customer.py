import json
from entities.Scrip import Scrip
from statics.Utils import parse_scrip, is_scrip_valid
__author__ = 'alirezasadeghi'

import errno
import functools
from tornado import ioloop
import socket
import random
import traceback
import sys
from entities.Message import RequestBrokerScrip, RequestVendorScrip,\
    RequestBuyProduct




customer_port_number = random.randint(1235, 50000)
BROKER_PORT = 1234
#===============================================================================
# fj
#===============================================================================
money = 1000
borker_scrips = []
# for picking a vendor scrip, we must search and find one which has same vendor id as
# vendor we want to purchase from.
vendor_scrips = []
products = []

















print("#################### Creating broker socket #########################")
broker_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
try:
    broker_sock.connect(("127.0.0.1", BROKER_PORT))
except socket.error as errmsg:
    traceback.print_exc()
    print("Something bad happened when trying to connect to broker.")
    sys.exit()


print("#################### Creating vendor socket #########################")

vendor_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
vendor_sock.setblocking(0)

# fj
vendor_port_number = 0

while vendor_port_number != -1:
    vendor_port_number = input("Enter vendor port to connect to?")
    try:
        vendor_sock.connect(("127.0.0.1", vendor_port_number))
    except socket.error as e:
        traceback.print_exc()
        vendor_port_number = random.randint(1235, 50000)
        continue



### Acts as broker to customers requests
customer_sock.listen(128)
print("#################### Customer socket bound #########################")

io_loop = ioloop.IOLoop.instance()
callback = functools.partial(customer_connection_ready, customer_sock)
print("#################### Attaching customer callback #1 #########################")
io_loop.add_handler(customer_sock.fileno(), callback, io_loop.READ)
print("#################### Attached customer callback #1 #########################")





#===============================================================================
# fj
#===============================================================================

def handle_connection(connection, address, arg):
    # print("#################### Callback #2 Called !!! :D #########################")
    message = connection.recv(1024)
    print("msg received : ", message)

    msg = process_msg(message)

    if msg["type"] == "ResponseBrokerScrip":
        scrip = parse_scrip(msg["data"][0])
        money -= scrip.amount
        add_broker_scrip(scrip)
        
        is_scrip_valid(scrip, "md5")
        
    
    elif msg["type"] == "ResponseVendorScrip":
        vendor_scrip = parse_scrip(msg["data"][0])
        
        add_vendor_scrip(vendor_scrip)
        
        broker_change = msg["data"][1]
        if broker_change:
            broker_change_scrip = parse_scrip(broker_change)
        add_broker_scrip(broker_change_scrip)
        
    
    elif msg["type"] == "ResponseProductInfo":
        return (msg["data"][0], msg["data"][1]) # name and price
     
    
    elif msg["type"] == "ResponseBuyProduct":
        products.append(parse_product(msg["data"][0])) # TODO: parse product from string
        vendor_change = msg["data"][1]
        if vendor_change:
            add_vendor_scrip(parse_scrip(vendor_change))



def send_msg(message, socket, crypto=None, key=None):
    '''
    sends the message into network. receiver
    '''

    socket.send(message.as_json().encode('utf-8'))


def add_broker_scrip(self, scrip):
    borker_scrips.append(scrip)
        
def add_vendor_scrip(self, scrip):
    vendor_scrips.append(scrip)    


def buy_broker_scrip(self, amount):
    '''
    requests a scrip from broker with the amount given.
    money will be reduced in processing the response.
    '''
    send_msg(RequestBrokerScrip(id, self.network.broker_id, amount), broker_sock)
    

def buy_vendor_scrip(amount, vendor_id):
    broker_scrip = find_broker_scrip(amount) # TODO: needs testing
    send_msg(RequestVendorScrip(id, broker_id, vendor_id, amount, broker_scrip))


def buy_product(vendor_id, product_price):
    vendor_scrip = find_vendor_scrip(product_price)
    send_msg(RequestBuyProduct(id, vendor_id, vendor_scrip))
        
    
def find_broker_scrip(amount):
    return __find_scrip(amount, borker_scrips)
     
def find_vendor_scrip(amount):
    return __find_scrip(amount, vendor_scrips)

def __find_scrip(amount, scrips):
    scrip = next(scrip for scrip in scrips if scrip.amount >= amount)
    scrips.remove(scrip)
    return scrip
 
 
def parse_product(string):
    '''
    return as a json ['name': name, 'price': price]
    '''
    # TODO:
    return json.loads(string)            
    


def process_msg(message):
    return json.loads(message)
    
    