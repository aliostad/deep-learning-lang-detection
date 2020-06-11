#
# -*- coding: utf-8 -*-

import AndroidFacade

from TGSSignals import TGSNewCommunitySignal, TGSCommunityInfoUpdatedSignal

from tgscore.square.community import SquareCommunity, PreviewCommunity

_global_broker = None

def createEventBroker(obj):
    global _global_broker
    if not _global_broker:
        _global_broker = TGSGlobalEventBroker()
    return _global_broker

class TGSGlobalEventBroker:
    def __init__(self):
        TGSCommunityEvent = AndroidFacade.CommunityEvent()
        self._squareUpdateEvent = TGSCommunityEvent
        self._newSquareUpdate = TGSNewCommunitySignal(self._squareUpdateEvent)
        self._squareInfoUpdated = TGSCommunityInfoUpdatedSignal(self._squareUpdateEvent)

    #TODO: use __gettattr__ for this.
    def newCommunityCreated(self, square):
        #self._tgs.newCommunityCreated.emit(square)
        self._newSquareUpdate.emit(square)
    def newPreviewCommunityCreated(self, square):
        # do we need this?
        #self._tgs.newPreviewCommunityCreated.emit(square)
        pass
    def newHotCommunitiesAvailable(self, squares, texts):
        # do we need this? (probably)
        #self._tgs.newHotCommunitiesAvailable.emit(squares, texts)
        pass
    def memberInfoUpdated(self, member):
        AndroidFacade.monitor('memberInfo updated: {}'.format(member))
    def messageReceived(self, text):
        AndroidFacade.monitor('message received: {}'.format(text))
    def squareInfoUpdated(self, square):
        AndroidFacade.monitor('square info updated: {}'.format(square))
        self._squareInfoUpdated.emit(square)
