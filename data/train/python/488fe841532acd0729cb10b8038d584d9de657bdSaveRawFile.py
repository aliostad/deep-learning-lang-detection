# -*- coding: utf-8 -*-
"""
Created on 2014-08-03

@author: Hengkai Guo
"""

import MIRVAP.Core.DataBase as db
from MIRVAP.Script.SaveBase import SaveBase

class SaveRawFile(SaveBase):
    def getName(self):
        return 'Save to raw files'
    def save(self, window, data):
        name, ok = self.gui.getInputName(window)
        if ok and name:
            name = str(name)
            data.setName(name)
            dir = './Data/' + name
            db.saveRawData(dir, self.gui.dataModel, window.index)
            return True
