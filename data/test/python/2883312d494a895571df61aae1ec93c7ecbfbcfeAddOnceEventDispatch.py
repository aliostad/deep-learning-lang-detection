# -*- coding: utf-8 -*-

from Libs.EventHandle.EventDispatch import EventDispatch;

'''
@brief 事件回调函数只能添加一次
'''

class AddOnceEventDispatch(EventDispatch):
    
    def __init__(self, eventId_ = 0):
        super(AddOnceEventDispatch, self).__init__(eventId_);
        
        self.mTypeId = "AddOnceEventDispatch";

    def addEventHandle(self, pThis, handle):
        # 这个判断说明相同的函数只能加一次，但是如果不同资源使用相同的回调函数就会有问题，但是这个判断可以保证只添加一次函数，值得，因此不同资源需要不同回调函数
        if (not self.existEventHandle(pThis, handle)):
            super(AddOnceEventDispatch, self).addEventHandle(pThis, handle);


