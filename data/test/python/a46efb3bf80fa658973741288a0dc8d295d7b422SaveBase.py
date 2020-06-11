# -*- coding: utf-8 -*-
"""
Created on 2014-03-05

@author: Hengkai Guo
"""

from MIRVAP.Core.ScriptBase import ScriptBase

class SaveBase(ScriptBase):
    def __init__(self, gui):
        super(SaveBase, self).__init__(gui)
    
    def run(self, window):
        window.save()
        data = window.getData()
        if self.save(window, data):
            self.gui.showErrorMessage('Success', 'Save sucessfully!')
        
    def save(self, window, data):
        raise NotImplementedError('Method "save" Not Impletemented!')
        
