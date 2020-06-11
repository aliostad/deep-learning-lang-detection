'''
Created on 2012-04-23

@author: Eran-Tasker
'''

import direct
from pandac.PandaModules import *
loadPrcFileData('', 'window-type none')
from direct.directbase.DirectStart import *

from direct.distributed.ServerRepository import ServerRepository

class MyServerRepository(ServerRepository):
    def __init__(self):
        tcpPort = base.config.GetInt('server-port', 4400)
        dcFileNames = ['direct.dc', 'net.dc']
        
        ServerRepository.__init__(self, tcpPort, None, dcFileNames = dcFileNames)
        print "server created, waiting."
        
server = MyServerRepository()
run()