'''
Created on 2013-4-22

@author: kfirst
'''

from flex.base.module import Module
from flex.api.listen_api import ListenApi
from flex.api.switch_api import SwitchApi
from flex.core import core
from flex.api.message_api import MessageApi
from flex.api.action_api import ActionApi
from flex.api.match_api import MatchApi
from flex.api.port_api import PortApi


class Api(Module):

    def __init__(self):
        self.listen_api = ListenApi()
        self.switch_api = SwitchApi()
        self.message_api = MessageApi()
        self.action_api = ActionApi()
        self.match_api = MatchApi()
        self.port_api = PortApi()
        self.storage_api = core.appStorage

    def start(self):
        self.listen_api.start()
        self.switch_api.start()
        self.message_api.start()
        self.action_api.start()
        self.match_api.start()
        self.port_api.start()
