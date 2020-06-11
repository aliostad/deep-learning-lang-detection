from entities.Node import Book, Service
__author__ = 'alirezasadeghi'

import errno
import functools
from tornado import ioloop
import socket
import random
import traceback
import sys

vendor_port_number = random.randint(1235, 50000)
BROKER_PORT = 1234
#===============================================================================
# fj
#===============================================================================
product__ = random.choice(Book, Service, )

def broker_handshake(connection, address, arg):
    print("Initiating the handshake")
    msg = connection.recv(1024)
    print("RECEIVED THIS GUY : ", msg)


def handle_customer_connection(connection, address):
    message = connection.recv(1024)
    print("Okay came here to handle the connection")



def customer_connection_ready(sock, fd, events):
    while True:
        try:
            connection, address = sock.accept()
        except socket.error as e:
            if e.args[0] not in (errno.EWOULDBLOCK, errno.EAGAIN):
                raise
            return

        connection.setblocking(0)
        tmp_callback = functools.partial(handle_customer_connection, connection)
        io_loop.add_handler(connection.fileno(), tmp_callback, io_loop.READ)


print("#################### Creating customer socket #########################")
customer_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
customer_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
customer_sock.setblocking(0)

while True:
    try:
        customer_sock.bind(("", vendor_port_number))
        break
    except socket.error as e:
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


### Acts as client to broker - sends its keys and stuff when created.
print("#################### Creating broker socket #########################")

broker_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
try:
    broker_sock.connect(("127.0.0.1", BROKER_PORT))
except socket.error as errmsg:
    traceback.print_exc()
    print("Something bad happened when trying to connect to broker.")
    sys.exit()

print("#################### Attaching broker callback #1 #########################")
broker_handshake_callback = functools.partial(broker_handshake, broker_sock)
io_loop.add_handler(broker_sock.fileno(), broker_handshake_callback, io_loop.READ)
print("#################### Attached broker callback #1 #########################")

print("#################### Okay trying to send initial data to broker #########################")
#TODO -> Send all the secret keys of vendor to broker

broker_sock.send("Hey are you there ?".encode('utf-8'))
print("#################### Data should have been sent #########################")

io_loop.start()
