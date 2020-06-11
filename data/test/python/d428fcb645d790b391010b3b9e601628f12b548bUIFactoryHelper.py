from edat.ui.db.sqlite.SQLUiFactory import SQLUiFactory
from edat.ui.db.csv.CSVUIFactory import CSVUIFactory
from af.controller.data.CSVController import CSVController
from af.controller.data.SqliteController import SqliteController


class UIFactoryHelper:

    @staticmethod
    def get_factory(data_type):
        if data_type == SqliteController.CONTROLLER_TYPE:
            return SQLUiFactory()
        if data_type == CSVController.CONTROLLER_TYPE:
            return CSVUIFactory()
        raise NotImplementedError()
