# encoding=utf8

""" The dispatch
    Author: lipixun
    Created Time : 五  4/ 8 15:40:18 2016

    File Name: dispatch.py
    Description:

"""

from unifiedrpc.protocol.dispatch import DispatchResult

class WebDispatchResult(DispatchResult):
    """The web dispatch result
    """
    def __init__(self, webEndpoint, endpoint, parameters, service = None):
        """Create a new WebDispatchResult
        """
        self.webEndpoint = webEndpoint
        # Super
        super(WebDispatchResult, self).__init__(endpoint, parameters, service)
