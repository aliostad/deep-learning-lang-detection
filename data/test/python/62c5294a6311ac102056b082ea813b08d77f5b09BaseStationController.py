import PyQt4
from PyQt4.Qt import pyqtSlot
from controller.RocketController import RocketController
from controller.Communication import SerialController
from controller.Communication import RFD900Strategy, XbeeStrategy, FrameFactory
from model.BaseStation import BaseStation
from model.Rocket import Rocket
from controller.GPS import GlobalSat
from Exception import SerialDeviceException
from controller.LogController import LogController


class BaseStationController(PyQt4.QtCore.QObject):
    __INSTANCE = None

    def __init__(self):
        super(BaseStationController, self).__init__()
        self.__LOGGER = LogController.getInstance()

        self.__rocketController = RocketController.getInstance()
        self.__baseStationModel = BaseStation()
        self.__RFD900SerialController = SerialController()
        self.__XBeeSerialController = SerialController()
        self.__globalSatSerialController = SerialController()
        self.__RFD900 = RFD900Strategy(self.__rocketController, self.__RFD900SerialController.serialConnection)
        self.__XBee = XbeeStrategy(self.__rocketController, self.__XBeeSerialController.serialConnection)

        self.setupSerialDevices()

        self.__gpsDevice = GlobalSat(self.__globalSatSerialController)
        self.__RFD900.rocketDiscovered.connect(self.__on_rocketDiscovery)
        self.__gpsDevice.coordsReceived.connect(self.__on_coordsReceived)

    def setupSerialDevices(self):

        self.__RFD900SerialController.updateSerialConnectionDeviceName("RFD 900")
        self.__RFD900SerialController.updateSerialConnectionPort('/dev/ttyS1')
        self.__RFD900SerialController.updateSerialConnectionBaudrate(57600)
        self.__XBeeSerialController.updateSerialConnectionDeviceName("XBEE")
        self.__XBeeSerialController.updateSerialConnectionPort("/dev/ttyS0")
        self.__XBeeSerialController.updateSerialConnectionBaudrate(9600)
        self.__globalSatSerialController.updateSerialConnectionDeviceName("GlobalSat GPS")
        self.__globalSatSerialController.updateSerialConnectionPort("/dev/ttyS1")
        self.__globalSatSerialController.updateSerialConnectionBaudrate(4800)


    def connectSerialDevices(self):
        try:
            self.__RFD900.connect()
            self.__XBee.connect()
            self.__gpsDevice.connect()
        except SerialDeviceException.UnableToConnectException as e:
            self.__LOGGER.error(e.message)
            raise

    @property
    def baseStation(self):
        return self.__baseStationModel

    @baseStation.setter
    def baseStation(self, baseStationModel):
        self.__baseStationModel = baseStationModel

    @property
    def rocketController(self):
        return self.__rocketController

    @rocketController.setter
    def rocketController(self, rocketController):
        self.__rocketController = rocketController

    @property
    def RFD900SerialController(self):
        return self.__RFD900SerialController

    @property
    def XBeeSerialController(self):
        return self.__XBeeSerialController

    @property
    def GlobalSatSerialController(self):
        return self.__globalSatSerialController

    @GlobalSatSerialController.setter
    def GlobalSatSerialController(self, serialController):
        self.__globalSatSerialController = serialController

    @property
    def RFD900(self):
        return self.__RFD900

    @RFD900.setter
    def RFD900(self, rfdCommStrategy):
        self.__RFD900 = rfdCommStrategy

    @property
    def XBee(self):
        return self.__XBee

    @XBee.setter
    def XBee(self, xbeeCommStrategy):
        self.__XBee = xbeeCommStrategy

    @property
    def GPS(self):
        return self.__gpsDevice

    @GPS.setter
    def GPS(self, gpsDevice):
        self.__gpsDevice = gpsDevice

    def updateAvailableRocket(self):

        self.__baseStationModel.availableRocket = {}
        self.__RFD900.sendData(FrameFactory.COMMAND['ROCKET_DISCOVERY'])

    def updateConnectedRocket(self, rocketID):

        self.__baseStationModel.connectedRocket = self.__baseStationModel.availableRocket[rocketID]
        self.__rocketController.rocket = self.__baseStationModel.connectedRocket

    def disconnectFromRocket(self, rocketID):

        if self.__baseStationModel.connectedRocket.ID == rocketID:
            self.__baseStationModel.connectedRocket = None
            self.__rocketController.rocket = self.__baseStationModel.availableRocket[Rocket.DISCOVERY_ID]

    @pyqtSlot(int)
    def __on_rocketDiscovery(self, rocketID):

        self.__baseStationModel.addAvailableRocket(Rocket(ID=rocketID, name=Rocket.NAME[rocketID]))

    @pyqtSlot(float, float)
    def __on_coordsReceived(self, latitude, longitude):

        self.baseStation.coords = {"latitude": latitude, "longitude": longitude}

    @staticmethod
    def getInstance():

        if BaseStationController.__INSTANCE is None:
            BaseStationController.__INSTANCE = BaseStationController()

        return BaseStationController.__INSTANCE
