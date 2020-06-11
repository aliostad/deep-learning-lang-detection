'''
Created on April 05, 2013

@author: AxelVoitier
@license: GNU LGPL v3

Python module allowing to create a ALBroker as if it was a contextmanager (use with the 'with' statement).
It will also try to resolve automatically all IPs and ports of NaoQis we could connect to.
'''

import socket
from contextlib import contextmanager
from naoqi import ALBroker
from naoutil import avahi

def getLocalIp(destAddr):
    '''
    Return the IP of the *net interface capable of reaching destAddr.
    '''
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect((destAddr, 0))
    ip = s.getsockname()[0]
    s.close()
    return ip
    
class Broker(ALBroker):
    '''
    Create a broker with the given name.
    Automatically find out NAO IP. Set the broker to listen only on the IP that is on the same network than NAO.
    You can specify brokerIp to listen to localhost only (127.0.0.1) or to everybody (0.0.0.0).
    
    When you are finished with your broker, call the shutdown() method on it.
    '''
    def __init__(self, brokerName, brokerIp=None, brokerPort=0, naoIp=None, naoPort=None):
        # Resolve NAO ip/port
        if naoIp is None:
            naoPort = None # Ensure consistency. Do not support specifying only port.
        else:
            naoIp = str(naoIp)
        if naoPort is None:
            allNaos = avahi.findAllNAOs()
            if naoIp is not None: # A NAO address is given, but not the port. Find it.
                for aNao in allNaos:
                    if naoIp in aNao.values():
                        naoPort = aNao['naoqi_port']
                        break
                if naoPort is None: # Can't find it in Avahi results
                    naoPort = 9559 # Try default port
            else: # Find the most likely NAO
                for aNao in allNaos:
                    if aNao['local']: # Prefer to connect to the local naoqi if there
                        naoIp = aNao['ip_address']
                        naoPort = aNao['naoqi_port']
                        break
                if naoIp is None: # No local NAO detected
                    if allNaos: # Try to get the first NAO detected by Avahi
                        naoIp = allNaos[0]['ip_address']
                        naoPort = allNaos[0]['naoqi_port']
                    else: # Fallback on nao.local/9559
                        naoIp = 'nao.local'
                        naoPort = 9559
        else:
            naoPort = int(naoPort)
                    
        # Information concerning our new python broker
        if brokerIp is None:
            brokerIp = getLocalIp(naoIp)
      
        ALBroker.__init__(self, brokerName, brokerIp, brokerPort, naoIp, naoPort)
    
@contextmanager
def create(brokerName, brokerIp=None, brokerPort=0, naoIp=None, naoPort=None):
    '''
    Create a broker with the given name.
    Automatically find out NAO IP. Set the broker to listen only on the IP that is on the same network than NAO.
    You can specify brokerIp to listen to localhost only (127.0.0.1) or to everybody (0.0.0.0).
    
    It acts as a context manager. Which means, use it with the 'with' statement. Example:
    
    with broker.create('MyBroker') as myBroker:
        print myBroker.getGlobalModuleList()
        raw_input("Press ENTER to terminate the broker")
    # Outside of the with, the broker has been shutdown.
    '''
    broker = Broker(brokerName, brokerIp, brokerPort, naoIp, naoPort)
    yield broker
    broker.shutdown()

