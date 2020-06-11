#!/usr/bin/env python
import sys
from socket import *
from Message import *
from Broker import *
from BrokerCallBack import *

b = Broker()
bc = BrokerCallBack()
b.registerCallBack(bc)
b.setAuthenticationData(sys.argv[1],"test")
b.setServerName("AztecServer")

b._registrarAddress = sys.argv[2]
#b._registrarAddress = '130.212.3.51'


b.init()

# testing connection to server on thecity
#b._serverAddress = '10.0.0.5'
#b._objectID = 103884;
#b._clientAddress = '10.0.0.4'
# testing connection to server on thecity

m = Message()
m.setString("subject","Hello World")
m.setString("message","Hello Server, I'm the client and I send you a message......")
m.setDouble("size", 1.75)
#b.send(m)
