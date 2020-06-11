#!/usr/bin/env python
# -*- coding: utf-8 -*-

from component.controller import JDController
from company.controller import CompanyListController
from product.controller import ProductListController
from entry.view import MainEntryFrame
import wx


class MainEntryController(JDController):
    def __init__(self):
        JDController.__init__(self)
        self.view = MainEntryFrame()

        self._bind_events()

    def _company_manage_button_clicked(self, event):
        CompanyListController().show_view()
        event.Skip()

    def _product_manage_button_clicked(self, event):
        ProductListController().show_view()
        event.Skip()

    def _bind_events(self):
        self.view.company_manage_button.Bind(wx.EVT_BUTTON, self._company_manage_button_clicked)
        self.view.product_manage_button.Bind(wx.EVT_BUTTON, self._product_manage_button_clicked)
