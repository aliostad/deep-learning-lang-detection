'''
Created on 14/ago/2012

@author: Francesco Capozzo
'''
from myclips_server.xmlrpc.services.Service import Service
import importlib
from myclips_server.xmlrpc.services import sessions


class Services(Service):
    '''
    Allow to manage published services in the broker
    '''

    _NAME = "AdminServices_Services"
    _TYPE = "AdminServices"
    __API__ = Service.__API__ + ["restart", "install", "replace", "remove", "refresh", "start", "renew"]
    
    def start(self, aServiceName, asType=None):
        theService = self._factory.instance(aServiceName)
        theService.setBroker(self._broker)
        if asType is not None:
            serviceKey = asType
        else:
            serviceKey = theService._NAME
        self._broker._services[serviceKey] = theService
        setattr(self._broker, serviceKey, theService)
        
        return serviceKey
    
    def restart(self, aServiceName):
        theService = self._broker._services[aServiceName]
        theModule = theService.__class__.__module__
        theServiceClass = theService.__class__.__name__
        self.replace(aServiceName, theModule, theServiceClass)
        return True
        
    
    def install(self, moduleName, className, aServiceName=None):
        theModule = importlib.import_module(moduleName)
        reload(theModule)
        theService = getattr(theModule, className)(self._factory)
        theService._onInitCompleted()
        theService.setBroker(self._broker)
        if aServiceName is not None:
            serviceKey = aServiceName
        else:
            serviceKey = theService._NAME
        self._broker._services[serviceKey] = theService
        setattr(self._broker, serviceKey, theService)
        
        return serviceKey
    
    def replace(self, aServiceName, moduleName, className):
        theModule = importlib.import_module(moduleName)
        theServiceClass = className
        reload(theModule)
        theService = getattr(theModule, theServiceClass)(self._factory)
        theService._onInitCompleted()
        theService.setBroker(self._broker)
        self._broker._services[aServiceName] = theService
        setattr(self._broker, aServiceName, theService)
        return True
    
    def remove(self, aServiceName):
        del self._broker._services[aServiceName]
        delattr(self._broker, aServiceName)
        
    def refresh(self, aModule):
        aModule = importlib.import_module(aModule)
        reload(aModule)
        
    @sessions.renewer
    def renew(self, aSessionToken):
        return True
