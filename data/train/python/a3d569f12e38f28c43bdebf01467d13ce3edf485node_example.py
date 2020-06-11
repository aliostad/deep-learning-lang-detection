""" Just a pseudo session of what I'd LIKE to happen. :) """

from zerotask.task import task
from zerotask.node import Node

@task
def add(x, y):
    return x, y

@task(name="namespaces.are.awesome.foo")
def foo():
    return "bar"

@task
def sleep(seconds):
    time.sleep(seconds)
    return True

@task
def some_broken_func():
    undeclared = awesome + unknown_symbol


node = Node()
node.start()
# automatically starts and listens to broker on tcp://*:5555,
# or...

node = Node()
node.add_broker("tcp://some.domain:5555")
# would love to eventually support broker "cluster", or at least
# broker master / slaves w/ auto failover
node.start(address="192.168.0.15") # visible on local network

#potential options
node = Node(workers=10)
