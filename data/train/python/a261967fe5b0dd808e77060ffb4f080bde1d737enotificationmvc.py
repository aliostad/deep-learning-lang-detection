from notification.AlertController import AlertController
from notification.LayoutController import LayoutController
from notification.ListController import ListController
from notification.NotificationsModel import NotificationsModel

class _NotificationMVC:

    def __init__(self):
        self.__model = None
        self.__alertsController = None
        self.__listController = None
        self.__layoutController = None
        return

    def initialize(self):
        self.__model = NotificationsModel()
        self.__alertsController = AlertController(self.__model)
        self.__listController = ListController(self.__model)
        self.__layoutController = LayoutController(self.__model)

    def getModel(self):
        return self.__model

    def getAlertController(self):
        return self.__alertsController

    def cleanUp(self):
        self.__alertsController.cleanUp()
        self.__listController.cleanUp()
        self.__layoutController.cleanUp()
        self.__model.cleanUp()
        self.__alertsController = None
        self.__listController = None
        self.__layoutController = None
        self.__model = None
        return


g_instance = _NotificationMVC()
