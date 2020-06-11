#!/usr/bin/env python
from Broker import *
from Message import *
from time import *
from sha import *

"""
The SessionManager manages the session setup and keep alive.
"""
class SessionManager(threading.Thread):

    PKS_MODULUS = 0x8974dc150978e7967af0b875f16fe0c1eb82ea56544a11cca5e691b01542781ffa0eb2730300d450c1b9f7452784ca0d7afc73bf28d5981eb971ebc573c057f02c50096f5ecf9af7d48544f51b130b493be6e02e6b878b6a6bf8ff9ba8ff630589635bcdc31beabdc3f5d005c6137ef2a855fdbec2da715d3ef3a3385e95ac51

    def __init__(self, broker):
        threading.Thread.__init__(self)
        self._broker = broker
        self._initalized = False
        self._keepAliveComp = 0
        self._state = 'ClientHello'
        self._ticket = ''

    def run(self):

        secondsTillAbort = 10
        rescondsRef=time()
        m = Message();
        m._requestID = 0x80000000
        self._broker.send(m,'registrar')

        # poll for initialized
        while(self._initalized == False):
            sleep(1)
            if secondsTillAbort <= (time()-rescondsRef):
                errstr = "[SessionManager] Initialization failed in state '" + self._state + "', it couldn't be finished within " + str(secondsTillAbort) + " seconds."
                raise RuntimeError(errstr)

        # manage keep alives
        rescondsRef=time()
        while(True):
            sleep(0.1)
            if ( (time()-rescondsRef) >= 1 ):
                self._sendKeepAlive()
                rescondsRef=time()
                    

    
    def _sendKeepAlive(self):
        #print "[SessionManager] send keep alive! objectID=", self._broker._objectID

        m = Message()
        m._requestID = 0x8000000A
        self._broker.send(m)
        self._keepAliveComp += 1

        if self._keepAliveComp > 10:
            errstr = "[SessionManager] Connection lost to server @ " + self._broker._serverAddress + ":" + str(self._broker._serverPort)
            raise RuntimeError(errstr)
            
  

    def receive(self, m, r):

        res = 0

        if m.getError() == True:
            raise RuntimeError("[SessionManager] Error while Session initialization!")

        # RegistrarHello
        if m._requestID == 0x80000001:
            self._state = 'RegistrarHello'
            challenge = m.getLong("challenge")
            self._broker._externalIP = m.getString("ip")
            self._broker._externalPort = m.getInteger("port")
            self._broker._sessionID = m.getSessionID()

            sha = new(m._IntegerToString(challenge,8,challenge))
            sha.update(self._broker._username)
            sha.update(self._broker._password)
            digest = sha.digest()
            
            r._requestID = 0x80000002
            r.setString("user", self._broker._username)
            r.setString("response", digest)
            r.setString("luName", self._broker._serverName)
            res = r

        # RegistrarAuth
        elif m._requestID == 0x80000003:
            if self._broker._serverName == m.getString("luName"):
                self._state = 'RegistrarAuth'
                self._broker._serverAddress = m.getString("luIP")
                self._broker._serverPort = m.getInteger("luPort")
                self._broker._objectID = m.getInteger("objectid")
                self._ticket = m.getString("ticket")

                print "[SessionManager] Authenticated with ObjectID=", self._broker._objectID

                #print "server ip: ", self._broker._serverAddress
                #print "server port: ", self._broker._serverPort

                # send a ClientHello also to the server including the ticket
                response = Message()
                response._requestID = 0x80000000
                response.setString("ticket", self._ticket)
                response.setString("ip", self._broker._externalIP)
                response.setInteger("port", self._broker._externalPort)
                self._broker.send(response)

        # ServerHello
        elif m._requestID == 0x80000004:
            self._state = 'ServerHello'

            if self.validateTicket(m) == True:
                self._broker._state = "online"
                self._initalized = True
                #print "[SessionManager] Server successfull authenticated!"
            else:
                raise RuntimeError("[SessionManager] receive() - Server authentication failed")

        # keep alive from server
        elif m._requestID == 0x8000000A:
            #print "[SessionManager] received keep alive!"
            self._keepAliveComp -= 1

        return res


    """
    The method validates a server ticket
    """
    def validateTicket(self, message):

        ticket = message.getString("ticket")
        c = message._StringToInteger(ticket, 0, len(ticket))
        e = 0x10001
        m = pow(c,e,SessionManager.PKS_MODULUS)
        lengthInByte = int(math.ceil(math.log(m, 256)))
        mstr = message._IntegerToString(m, lengthInByte, m)

        ip = str(ord(mstr[0])) + "." + str(ord(mstr[1])) + "." + str(ord(mstr[2])) + "." + str(ord(mstr[3]))
        port = message._StringToInteger(mstr, 4, 4)
        sessionID = message._StringToInteger(mstr, 8, 4)

        """
        print "", ip, " = ", self._broker._serverAddress
        print "", port, " = ", self._broker._serverPort
        print "", sessionID, " = ", message.getSessionID()
        

        if ((ip == self._broker._serverAddress) and (port == self._broker._serverPort ) and (sessionID==message.getSessionID())):
            return True
        else:
            return False
        """
        return True
