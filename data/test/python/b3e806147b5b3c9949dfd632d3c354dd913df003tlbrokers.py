"""

tlBrokers

Store, retrieve, list and find Brokers. Broker get and set params
"""

from lib.tlsettings import tlSettings as Settings
from lib.tllogging import tlLogging as Log
from PyQt4.QtCore import QFile, QIODevice, QObject, pyqtSignal
from PyQt4.QtGui import QFileDialog
from qgis.core import QgsProject

import json, os.path, sys,copy, traceback


class BrokerNotFound(Exception):
    pass


class BrokerNotSynced(Exception):
    pass


class BrokersNotDefined(Exception):
    pass


class tlBrokers(QObject):
    """
    Class to manage array of Brokers including storage
    
    """

    _this = None
    brokersLoaded = pyqtSignal(object)

    kDefaultFile = "brokers.json.default"
    kBrokerFile = 'brokerFile'
    kBrokerList = "brokers/list"

    @staticmethod
    def instance():
        return tlBrokers._this

    def __init__(self, pluginDir):
        super(tlBrokers, self).__init__()
        self._jsonfile = None
        self._loaded = False
        self._dirty = False
        self._brokers = {}
        self._oldBrokers = None
        self._dirty = False
        self._dirtyList = []
        self._defaultFile = os.path.join(pluginDir, self.kDefaultFile)
        self._jsonfile = Settings.get("brokerFile", self._defaultFile)
        tlBrokers._this = self
        QgsProject.instance().readProject.connect(self.load)

        self.load()

    def importFile(self,filename = None):
        try:
            if not filename:
                filename = self._jsonfile
            if os.path.exists(filename):
                return json.loads(open(filename).read())
            else:
                # no file available
                Log.debug("Broker file " + filename + " not found!")
        except Exception as e:
            Log.critical(e)

        self._dirty = False
        return ""
        pass


    def load(self):
        try:
            jsonstr = Settings.get(self.kBrokerList)
            if not jsonstr:
               Log.debug("Load brokers from file") 
               self._brokers = dict(self.importFile()) # backward compatible
            else:
               self._brokers = dict(json.loads( jsonstr ))

            self._validate()
            #Log.debug(self._dirtyList)
            self.brokersLoaded.emit(self._dirtyList)
            self._dirtyList[:] = []
        except Exception as e:
            Log.debug("Error loading broker: " + str(e))
            exc_type, exc_value, exc_traceback = sys.exc_info()
            Log.debug(repr(traceback.format_exception(exc_type, exc_value,
                                                      exc_traceback)))
        finally:
            self._dirty = False

    def _file(self):
        if self._jsonfile == self._defaultFile:
            fileName = QFileDialog.getSaveFileName(None, "Location for Brokers File",  # translate
                                                   "~/",
                                                   "*.json")
            if fileName:
                Settings.set(self.kBrokerFile, fileName)
                self._jsonfile = fileName
            else:
                Log.critical("Broker data being saved to plugin directory and will be lost on upgrade!")

        return self._jsonfile

    def sync(self, load=True):
        try:
            Settings.set(self.kBrokerList,json.dumps(self._brokers))
        except Exception as e:
            Log.critical(e)
        if load:
            self.load()

    def exportFile(self):
        if not self._dirty:
            return
        try:
            with open(self._file(), 'w') as f:
                json.dump(f)
            self._dirty = False
            if load:
                self.load()
        except Exception as e:
            Log.critical(e)


    def uniq(self):
        if not self._brokers:
            return 1
        return int(max(self._brokers.keys(), key=int)) + 1

    def uniqName(self, bid, name):
        uniq = True
        for broker in self.list():
            if bid != broker.id() and broker.name() == name:
                uniq = False
                break
        return uniq


    def list(self, reverse=False):
        brokers = []
        if not self._brokers:
            return []
        for bid, brokerprops in self._brokers.iteritems():
            brokers.append(tlBroker(bid, brokerprops))
        if reverse:
            brokers.reverse()
        return brokers
    
    def find(self, bid):
  
        try:
            return tlBroker(bid, self._brokers[bid])
        except:
            return None

    def findByName(self, name):
        broker = None
        try:
            for _broker in self.list():
                if name == _broker.name():
                    broker = _broker
            return broker
        except:
            return None

    def create(self, name=None, host="localhost", port=1883):
        broker = tlBroker(self.uniq())
        if name is None:
            broker.setName("Broker" + str(broker.id()))
        broker.setHost(host)
        broker.setPort(port)
        broker.setPortAlt(port)
        broker.setPoll(0)
        broker.setKeepAlive(0)
        broker.setUseAltConnect(False)
        broker.setDirty(True)
        self._brokers[broker.id()] = broker.properties()
        return broker

    def update(self, broker):
        try:
            self._brokers[broker.id()] = broker.properties()
            if broker.dirty():
                self._dirty = True
                self._dirtyList.append(broker.id())
        except IndexError:
            Log.cricital("Broker not found  " + str(broker.id()))
            
        pass

    def delete(self, broker):
        try:
            del self._brokers[broker.id()]
        except IndexError:
            pass
        self._dirty = True
        pass

    
    def _validate(self):
        pass

    def dirty(self):
        return self._dirty


class tlBroker(QObject):
    """
    Class to represent a single Broker
    
    """
    deletingBroker = pyqtSignal()

    def __init__(self, brokerId, properties={},dirty = False):
        self._properties = properties
        self.setId(brokerId)
        self._dirty = dirty
        super(tlBroker, self).__init__()
        pass

    def properties(self):
        return self._properties


    def id(self):
        return self.get("id")

    """ Setters """

    def set(self, key, value):
        self._properties[key] = value

    def setId(self, id):
        self.set('id', id)

    def setName(self, name):
        self.set('name', name)

    def setUsername(self, username):
        self.set('username', username)

    def setPassword(self, password):
        self.set('password', password)

    def setHost(self, host):
        self.set('host', host)

    def setHostAlt(self, host):
        self.set('hostAlt', host)

    def setUseAltConnect(self,state):
        self.set('useAltConnect',state)

    def setPort(self, port):
        self.set('port', port)

    def setPortAlt(self, port):
        self.set('portAlt', port)

    def setPoll(self, poll):
        self.set('poll', poll)

    def setKeepAlive(self, keepalive):
        self.set('keepalive', keepalive)


    """ Getters """

    def get(self, key, default=None):
        if key in self._properties:
            return self._properties[key]
        return default

    def name(self):
        return self.get('name')

    def username(self):
        return self.get('username')

    def password(self):
        return self.get('password')

    def host(self):
        if not self.useAltConnect():
            return self.get('host')
        else:
            return self.get('hostAlt')

    def port(self):
        if not self.useAltConnect():
            return self.get('port')
        else:
            return self.get('portAlt')

    def hostAlt(self):
        return self.get('hostAlt')

    def portAlt(self):
        return self.get('portAlt')

    def poll(self, poll=0):
        if self.get('poll') is None:
            return poll
        return self.get('poll')

    def keepAlive(self):
        return self.get('keepalive')

    def useAltConnect(self):
        if self.get('useAltConnect',False):
            return True
        return False

    
    def setDirty(self,state = True):
        self._dirty = state
    
    def dirty(self):
        return self._dirty

    def clone(self):
        return copy.copy(self) 
