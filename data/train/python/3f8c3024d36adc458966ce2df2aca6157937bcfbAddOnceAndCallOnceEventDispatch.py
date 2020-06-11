# -*- coding: utf-8 -*-

from Libs.EventHandle.EventDispatch import EventDispatch;

class AddOnceAndCallOnceEventDispatch(EventDispatch):
    def __init__(self):
        super(AddOnceAndCallOnceEventDispatch, self).__init__();
        
        self.mTypeId = "AddOnceAndCallOnceEventDispatch";
        
    def addEventHandle(self, pThis, handle):
        if (not self.existEventHandle(pThis, handle)):
            super(AddOnceAndCallOnceEventDispatch, self).addEventHandle(pThis, handle);


    def dispatchEvent(self, dispatchObject):
        super(AddOnceAndCallOnceEventDispatch, self).dispatchEvent(dispatchObject);
        self.clearEventHandle();

