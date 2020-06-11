#!/usr/bin/python

"""
@author Jerome Monceaux
Aldebaran Robotics (c) 2007 All Rights Reserved - This file is confidential.

To use this file soapPy is required

Version : $Id$
"""

import SOAPpy
import os
import threading

class ALError(Exception):
    """Class for ALLib related errors."""
    def __init__ (self, who, mess, detail):
        "Creates an exception."
        self.who =who
        self.mess = mess
        self.detail = detail
        Exception.__init__(self, self.who, self.mess, self.detail)
    def __str__(self):
        "Calculates the string representation."
        s = '\n\ALError from %s : %s\n Detail: %s\n' % (self.who, self.mess, self.detail)
        return s
    __repr__ = __str__

class ALModuleInfo():
    """structure containing module information"""
    def __init__(self):
        self.processId = -1
        self.name = "no name"
        self.ip = -1
        self.port = -1
        self.modulePointer = -1
        self.architecture = -1
        self.isABroker = 1

class ALModule():
    """generic class used to define a module"""
    def __init__(self):
        """docstring for %s"""
        pass
    def execute( self, methodName, param ):
        # return result
        return
    def getMethodList( self):
        #return the module's list methods
        return
    def getMethodHelp( self, methodName ):
        #return a string containing method description
        return
    def moduleHelp( self ):
        #return module description as string
        return
    def dataChanged( self, dataName, value, message ):
        return
    def version( self ):
        # return version number as string
        return
    def getName( self ):
        # return name as string
        return
    def setParentBroker( self, albroker ):
        # albroker must be an ALBroker instance (pointer /reference ??)
        # JM 20/01/08 : Not shure is usefull in python
        return
    def getModuleInfo( self ):
        # return an ALModuleInfo struct
        return
    def bindMethod( self ):
        return
    def setModuleDescription( self ):
        return


class ALBroker(threading.Thread):
    """ALBroker create a soap server. It expose soap methods to communicate with python modules."""
    def __init__(self, name, parentIP = "127.0.0.1", parentPort=9559, brokerIP="127.0.0.1", brokerPort=0):
        if brokerPort == 0:
            raise ALError("ALBoker Python", "no port defined", "A port number must be specify to launch the python broker.")
        self.name = name
        self.ip = brokerIP
        self.port = brokerPort
        self.parentIP = parentIP
        self.parentPort = parentPort

        # Connect to the parent broker
        endpoint = parentIP + ":" + str(parentPort)
        print "endpoint of the broker : " + endpoint
        parentBroker = SOAPpy.SOAPProxy(endpoint)

        # create info of this broker
        self.brokerInfo = ALModuleInfo()
        self.brokerInfo.processId = -1
        self.brokerInfo.name = self.name
        self.brokerInfo.ip = self.ip
        self.brokerInfo.port = self.port
        self.brokerInfo.modulePointer = 0
        # JM 19/01/08 : OS is specify here as "other", in the future we can specify the current os, is it usefull ?
        self.brokerInfo.architecture = 3
        self.brokerInfo.isABroker = 1
        print "register Broker"
        parentBroker._ns("urn:albroker").registerBroker(self.brokerInfo, 1)
        threading.Thread.__init__ ( self )

    def callNaoqi( self, moduleName, methodName, param ): return
        # Must return a result
    def pCallNaoqi( self, moduleName, methodName ): return
    def getModuleByName( self, moduleName ):
        # return an ALModuleInfo if found
        return
    def exploreToGetModuleByName( self, moduleName, searchUp = 0, searchDown = 0, dontLookIntoBrokerName = ""):
        #must return an ALMoudleInfo structure
         return
    def getModuleList( self ):
        # return a list of ALModuleInfo
        return
    def registerBroker( self, brokerToRegister):
        # brokerToRegister is an ALModuleInfo structure
         return
    def getBrokerInfo( self ): return self.brokerInfo
    def dataChanged( self, moduleName, dataName, value, message): return
    def getMethodList( self, moduleName ):
        #return a list of methods
         return
    def getMethodHelp( self, moduleNAme, methodName ):
        #return a string discribing the methods
         return
    def init( self, brokerName = "", ip = "", port = -1, parentBrokerIP = "", parentBrokerPort = -1 ): return
    def version ( self, moduleName ):
        #return a string containing the module's version
         return
    def sendBackIP( self, unused ):
        #return the client ip
        return
    def getBrokerName ( self, unused ): return self.name
    def getInfo( self, moduleName ):
        #return a ALModuleInfo structure
         return

