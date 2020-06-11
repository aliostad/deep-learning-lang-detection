# -*- coding: UTF-8 -*-
'''
Created on 29/09/2010

@author: rodrigo
'''

from PyQt4 import QtCore, QtGui
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QMainWindow
from core.models import Trade, Broker
from datetime import date
from elixir import session
from main_ui import Ui_main
from ui.delegates import DateDelegate, OperationDelegate
from ui.models import TradeModel, BrokerModel, OperationListModel
import logging

class MainWindow(QMainWindow):

    log = logging.getLogger(__name__)

    trade_delegates = {1:DateDelegate(), 2:OperationDelegate()}

    def __init__(self, parent=None, flags=Qt.Widget):
        super(self.__class__, self).__init__(parent, flags)
        ui = Ui_main()
        self.ui = ui
        ui.setupUi(self)
        ui.operation.setModel(OperationListModel())
        ui.trade_list.setModel(TradeModel())
        for key in self.trade_delegates.keys():
            ui.trade_list.setItemDelegateForColumn(key, self.trade_delegates[key])
        ui.broker.setModel(BrokerModel())
        ui.broker.setModelColumn(0)
        ui.broker.model().setRows(Broker.query.all())
        ui.date.setDate(date.today())
        ui.month.setDate(date.today())
        ui.trade_list.horizontalHeader().setStretchLastSection(True)


    def on_month_dateChanged(self, date):
        self.load_trades()

    @QtCore.pyqtSlot()
    def on_add_clicked(self):
        ui = self.ui
        operation = ui.operation.model().operation(ui.operation.currentIndex())
        broker = ui.broker.model().getRow(ui.broker.currentIndex())
        trade = Trade(stock=ui.stock.text(),
                      date=ui.date.date().toPyDate(),
                      type=operation,
                      price=float(ui.price.text()),
                      quantity=int(ui.quantity.text()),
                      broker=broker)
        trade.calculateCost()
        session.commit()
        self.load_trades()

    def load_trades(self):
        self.log.debug("Carregando trades")
        initial = date(self.ui.month.date().year(), self.ui.month.date().month(), 30)
        final = date(self.ui.month.date().year(), self.ui.month.date().month() - 1, 1)
        model = self.ui.trade_list.model()
        if(model):
#            model.setRows(Trade.query.filter(initial <= Trade.date <= final).order_by(Trade.date).all())
            model.setRows(Trade.query.all())
